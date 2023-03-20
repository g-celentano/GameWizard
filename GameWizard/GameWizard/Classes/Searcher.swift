//
//  Searcher.swift
//  GameWizard
//
//  Created by Letterio Ugo Cangiano on 23/02/23.
//

import Foundation
import CoreData
import SwiftUI

func searchKeyword(keywords: [String], games: [Game], alreadySuggested: FetchedResults<AlreadySuggested>) -> String? {
    var maxMatches = 0
    var matchedGame : Game?
    var index = 0
    var keyIndex = 0
    
        for game in games {
            var matches = 0
            if game.keywords != nil {
                for _ in game.keywords! {
                    if !alreadySuggested.isEmpty{
                        if keywords.contains(where: {
                            games[index].keywords![keyIndex].name.lowercased().contains($0.lowercased())
                        }) && !alreadySuggested.contains(where: {
                            games[index].name.lowercased().contains($0.gameName!.lowercased())
                        })
                        {
                            matches += 1
                        }
                    } else {
                        if keywords.contains(where: {
                            games[index].keywords![keyIndex].name.lowercased().contains($0.lowercased())
                        }) 
                        {
                            matches += 1
                        }
                    }
                   
                    
                    keyIndex += 1
                }
            }
                                                    
            if matches > maxMatches {
                maxMatches = matches
                matchedGame = game
                
            }
            
            index += 1
            keyIndex = 0
        }
        index = 0
        keyIndex = 0
        maxMatches = 0
    
    return matchedGame?.name ?? ""
                         
}


func searchKeywords(keywords: [String], games: [Game], alreadySuggested: FetchedResults<AlreadySuggested>) -> [String?] {
    var maxMatches = 0
    var matchedGame : Game?
    var index = 0
    var keyIndex = 0
    var founds : [String?] = []
    var maxTries = 0
    
    while founds.count < 4 && maxTries < 4 {
        for game in games {
            var matches = 0
            if game.keywords != nil {
                for _ in game.keywords! {
                    if !alreadySuggested.isEmpty{
                        if keywords.contains(where: {
                            games[index].keywords![keyIndex].name.lowercased().contains($0.lowercased())
                        }) && !alreadySuggested.contains(where: {
                            games[index].name.lowercased().contains($0.gameName!.lowercased())
                        })
                        {
                            matches += 1
                        }
                    } else {
                        if keywords.contains(where: {
                            games[index].keywords![keyIndex].name.lowercased().contains($0.lowercased())
                        })
                        {
                            matches += 1
                        }
                    }
                
                    keyIndex += 1
                }
            }
                                                    
            if matches > maxMatches && !founds.contains(game.name) {
                maxMatches = matches
                matchedGame = game
                
            }
            
            index += 1
            keyIndex = 0
        }
        if matchedGame?.name != nil && matchedGame?.name != "" {
            founds.append(matchedGame?.name)
        }
        maxTries += 1
        index = 0
        keyIndex = 0
        maxMatches = 0
    }
    
    
        //return matchedGame?.name ?? "No game"
    return founds

                                                
}
