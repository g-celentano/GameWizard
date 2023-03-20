//
//  ResponseHandler.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 17/03/23.
//

import Foundation
import SwiftUI
import CoreData

import NaturalLanguage
import CoreML

struct Words: Codable {
    let words : [String]
}
struct Classes: Codable {
    let classes : [String]
}
struct Intents: Codable {
    let intents : [Single_Intent]
}
struct Single_Intent: Codable{
    let tag: String
    let patterns: [String]
    let responses: [String]
}

struct Tuple: Codable, Comparable{
    static func < (lhs: Tuple, rhs: Tuple) -> Bool {
        return lhs.value<rhs.value
    }
    
    let index: Int
    let value: Float32
}

struct Ints : Codable {
    let intent : String
    let probability : Float32
}


struct Response: Codable {
    let message : String
    let response_games : [Game]
}

class ResponseHandler {
    
    private let words: Words = load("words")
    private let classes: Classes = load("classes")
    private let intents: Intents = load("intents")
    var chatModel : MLModel?
    
    init() {
        do {
            self.chatModel = try chatbotMLmodel().model
        }
        catch{
            print(error)
            self.chatModel = nil
        }
        
    }
    
    func clean_sentence(sentence: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lemma, .lexicalClass])
        let clean_sentence = recommender.get_tokens(text: sentence)
        var final_res: [String] = []
        
        for word in clean_sentence {
            tagger.string = word
            tagger.enumerateTags(in: word.startIndex..<word.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
                if let tag = tag {
                    final_res.append(tag.rawValue)
                } else {
                    final_res.append(word[tokenRange].lowercased())
                }
                return true
            }
        }
        return final_res
    }
    
    func bag_of_words(sentence: String) -> MLMultiArray?{
        let sentence_words = self.clean_sentence(sentence:sentence)
        var bag: [Int] = []
        for _ in words.words{
            bag.append(0)
        }
        
        for w in sentence_words{
            for word in words.words{
                if word == w {
                    let index = words.words.firstIndex(of: word)!
                    bag[index] = 1
                }
            }
        }
        var ret : MLMultiArray? = nil
        do{
            ret = try MLMultiArray(shape: [1,322], dataType: .float32)
            for i in 0..<1 {
                for j in 0..<322{
                    ret![[i as NSNumber, j as NSNumber]] = bag[j] as NSNumber
                }
            }
        }catch{
            print(error)
        }
        
        return ret
        
    }
    
    func predict_class(sentence : String) -> [Ints]{
        let bow = self.bag_of_words(sentence: sentence)!
        var res : MLFeatureProvider? = nil
        var results: [Tuple] = []
        
        do {
            chatModel = try chatbotMLmodel().model
            res = try chatModel!.prediction(from: chatbotMLmodelInput(dense_input: bow))
            let ERROR_TRESH = 0.25
            for s in res!.featureNames{
                let predicted = res!.featureValue(for: s)!
                for i in 0..<1{
                    for j in 0..<4{
                        let value = predicted.multiArrayValue![[i as NSNumber, j as NSNumber]]
                        if Double(truncating: value) > ERROR_TRESH{
                            results.append(Tuple(index: j, value: Float32(truncating: value)))
                        }
                    }
                }
            }
        } catch{
            print(error)
        }
        
        
        results = results.sorted(by: >)
        var result_list : [Ints] = []
        for r in results{
            result_list.append(Ints(intent: classes.classes[r.index], probability: r.value))
        }
        
        return result_list
        
    }
    
    
    func getResponse( userMessage: String, already: FetchedResults<AlreadySuggested>, context: NSManagedObjectContext)-> Response{
        let intents_list = predict_class(sentence: userMessage)
        let tag = intents_list[0].intent
        let list_of_intents = intents.intents
        var final_response : String = ""
        var g: [Game] = []
        
        for intento in list_of_intents{
            if intento.tag == tag {
                final_response = intento.responses.randomElement() ?? "No response found"
                break
            }
        }
        if final_response.contains("%@") && tag == "game_request" {
            var noGame = ""
            if userMessage.contains("games"){
                noGame = userMessage.replacingOccurrences(of: "games", with: "")
            } else {
                noGame = userMessage.replacingOccurrences(of: "game", with: "")
            }
            
            if noGame.split(separator: " ").count > 2{
                g = self.getGames(lastUserInput: userMessage, alreadySuggested: already, context: context)
                
                if g.count == 1{
                    final_response = String(format: final_response, "\"\(g.last!.name)\"")
                } else if g.count > 1{
                    var gs = "\n"
                    for game in g {
                        print(game.name)
                        gs.append("✰ \(game.name)\n")
                    }
                    
                    final_response = String(format: final_response, "\(gs)")
                    
                } else {
                    final_response = NSLocalizedString("no game", comment: "")
                }
            } else {
                final_response = NSLocalizedString("Sorry", comment: "")
            }
            
        }
        
        
        return Response(message: final_response, response_games: g)
    }
    

    
    func getGames(lastUserInput: String, alreadySuggested: FetchedResults<AlreadySuggested>, context: NSManagedObjectContext) -> [Game] {
        
            if lastUserInput.contains(NSLocalizedString("games", comment: "")) {
                
                let newlastUserInput = lastUserInput.replacingOccurrences(of: NSLocalizedString("games", comment: ""), with: "")
                let response_games = searchKeywords(keywords: recommender.get_keywords(text: newlastUserInput), games: games, alreadySuggested: alreadySuggested)
                
                
                if !response_games.isEmpty {
                    var suggNames : [String] = []
                    var games_in_response : [Game] = []
                    
                    if !alreadySuggested.isEmpty{
                        for already in alreadySuggested {
                            suggNames.append(already.gameName!)
                        }
                    }
                    
                    for response in response_games {
                        if !suggNames.contains(response!){
                            let suggested = AlreadySuggested(context:context)
                            let suggestedGame = games.filter({ game in
                                game.name == response
                            })
                            suggested.gameName = suggestedGame[0].name
                            if suggestedGame[0].keywords != nil{
                                for key in suggestedGame[0].keywords! {
                                    suggested.keywords?.append(key.name)
                                }
                            }
                            if suggestedGame[0].genres != nil{
                                for genre in suggestedGame[0].genres!{
                                    suggested.genres?.append(genre.name)
                                }
                            }
                            if suggestedGame[0].similar_games != nil{
                                for similar in suggestedGame[0].similar_games!{
                                    suggested.similar_games?.append(similar.name)
                                }
                            }
                            try? context.save()
                             
                        }
                    }
                        for g in response_games{
                            let giuoco = games.filter { gioco in
                                gioco.name == g
                            }
                            games_in_response.append(giuoco[0])
                        }
                        return games_in_response
                         
                        
                    }
                
                } else if lastUserInput.contains(NSLocalizedString("game", comment: "")) {
                    let newlastUserInput = lastUserInput.replacingOccurrences(of: NSLocalizedString("game", comment: ""), with: "")
                    let response_games = searchKeyword(keywords: recommender.get_keywords(text: newlastUserInput), games: games, alreadySuggested: alreadySuggested)
                    
                    if !(response_games?.isEmpty ?? false) {
                        var suggNames : [String] = []
                        if !alreadySuggested.isEmpty{
                            for already in alreadySuggested {
                                suggNames.append(already.gameName!)
                            }
                        }
                        if !suggNames.contains(response_games!){
                            let suggested = AlreadySuggested(context: context)
                            let suggestedGame = games.filter({ game in
                                game.name == response_games
                            })
                            suggested.gameName = suggestedGame[0].name
                            for key in suggestedGame[0].keywords! {
                                suggested.keywords?.append(key.name)
                            }
                            for genre in suggestedGame[0].genres!{
                                suggested.genres?.append(genre.name)
                            }
                            for similar in suggestedGame[0].similar_games!{
                                suggested.similar_games?.append(similar.name)
                            }
                            try? context.save()
                        }
                        
                        let game = games.filter { g in
                            g.name == response_games!
                        }
                        
                        return [game[0]]
                         
                        }
                } else {
                    let response_games = searchKeyword(keywords: recommender.get_keywords(text: lastUserInput), games: games, alreadySuggested: alreadySuggested)
                    
                    if !(response_games?.isEmpty ?? false) {

                        let game = games.filter { g in
                            g.name == response_games!
                        }
                        var suggNames : [String] = []
                        if !alreadySuggested.isEmpty{
                            for already in alreadySuggested {
                                suggNames.append(already.gameName!)
                            }
                        }
                        if !alreadySuggested.isEmpty{
                            for already in alreadySuggested {
                                suggNames.append(already.gameName!)
                            }
                        }
                        if !suggNames.contains(response_games!){
                            let suggested = AlreadySuggested(context: context)
                            let suggestedGame = games.filter({ game in
                                game.name == response_games
                            })
                            suggested.gameName = suggestedGame[0].name
                            for key in suggestedGame[0].keywords! {
                                suggested.keywords?.append(key.name)
                            }
                            for genre in suggestedGame[0].genres!{
                                suggested.genres?.append(genre.name)
                            }
                            for similar in suggestedGame[0].similar_games!{
                                suggested.similar_games?.append(similar.name)
                            }
                            try? context.save()
                        }
                        return [game[0]]
                         
                    }
            
                }
        return []
    }
    
}
