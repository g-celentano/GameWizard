//
//  Recommender.swift
//  GameWizard
//
//  Created by Letterio Ugo Cangiano on 22/02/23.
//



import Foundation
import CoreML
import NaturalLanguage


class Recommender {
    private let tokenizer = NLTokenizer(unit: .word)
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])
    
    func get_tokens(text: String) -> [String] {
        var tokens : [String] = []
        self.tokenizer.string = text
        self.tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            
            tokens.append(String(text[tokenRange]))
            return true
        }
        return tokens
    }
    
    func get_sentiment(text:String) -> String {
        self.tagger.string = text
        var retValue = ""

        // Ask for the results
        let sentiment = self.tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0

        // Read the sentiment back and print it
        let score = Double(sentiment?.rawValue ?? "0") ?? 0

        // Print the right smiley based on sentiment
        if score == 0{
            retValue = "🙂"
        }
        else if score < 0{
            retValue = "😢"
        }
        else {
            retValue = "😁"
        }
        
        return retValue
    }
    
    func get_keywords(text: String) -> [String] {
        guard let modelFile = Bundle.main.url(forResource: "Keywords", withExtension: ".mlmodelc")
        else {
            fatalError("Could not find Model file.")
        }
        guard let modelFile2 = Bundle.main.url(forResource: "GameNames", withExtension: ".mlmodelc")
        else {
            fatalError("Could not find Model file.")
        }
        // Initialize the NLTagger with scheme type as "lemma"
        let tagger = NLTagger(tagSchemes: [.lemma])
        var array: [String] = []
        var keywordsModel: NLGazetteer
        var gameModel: NLGazetteer
        do {
            keywordsModel = try NLGazetteer(contentsOf: modelFile)
        } catch {
            fatalError()
        }
        do {
            gameModel = try NLGazetteer(contentsOf: modelFile)
        } catch {
            fatalError()
        }
        tagger.setGazetteers([keywordsModel], for: .lemma)
        // Set the string to be processed
        tagger.string = text
        // Loop over all the tokens and print their lemma
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
          if let tag = tag {
              //print(tokenRange)
              print("\(text[tokenRange]): \(tag.rawValue)")
              if (tag.rawValue == "keywords") {
                  array.append(String(text[tokenRange]))
              }
          }
          return true
        }
        return array
    }
}


/*
let text = """
All human beings are born free and equal in dignity and rights.
They are endowed with reason and conscience and should act towards one another in a spirit of brotherhood.
"""

/*
let tokenizer = NLTokenizer(unit: .word)
tokenizer.string = text

tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
    print(text[tokenRange])
    return true
}

// Initialize the NLTagger with scheme type as "lemma"
let tagger = NLTagger(tagSchemes: [.lemma])
// Set the string to be processed
tagger.string = text
// Loop over all the tokens and print their lemma
tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
  if let tag = tag {
      print("\(text[tokenRange]): \(tag.rawValue)")
  }
  return true
}

let string1 = """
Hello world, I love machine learning and I work as a Data Scientist in India.
機械学習で働くのが好き
"""
let string2 = "    أحب العمل في التعلم الآلي"

// Initialize LanguageRecognizer
let languageRecog = NLLanguageRecognizer()

// find the dominant language
languageRecog.processString(string1)
print("Dominant language is: \(languageRecog.dominantLanguage?.rawValue)")

// identify the possible languages
languageRecog.processString(string2)
print("Possible languages are:\(languageRecog.languageHypotheses(withMaximum: 2))")
    

let string = """
I started my schooling as the majority did in my area, at the local primarry school. I then
went to the local secondarry school and recieved grades in English, Maths, Phisics,
Biology, Geography, Art, Graphical Comunication and Philosophy of Religeon. I'll not
bore you with the 'A' levels and above.
"""

// find the dominant language of text
let dominantLanguage = NLLanguageRecognizer.dominantLanguage(for: string)

print(string+", has dominant language:\(dominantLanguage!.rawValue)")

// initialize UITextChecker, nsString, stringRange
let textChecker = UITextChecker()
let nsString = NSString(string: string)
let stringRange = NSRange(location: 0, length: nsString.length)
var offset = 0

repeat {
    // find the range of misspelt word
    let wordRange =
            textChecker.rangeOfMisspelledWord(in: string,
                                              range: stringRange,
                                              startingAt: offset,
                                              wrap: false,
                                              language: dominantLanguage!.rawValue)

    // check if the loop range exceeds the string length
    guard wordRange.location != NSNotFound else {
        break
    }

    // get the misspelt word
    print(nsString.substring(with: wordRange))

    // get some suggested words for the misspelt word
    print(textChecker.guesses(forWordRange: wordRange, in: string, language: dominantLanguage!.rawValue))

    // update the start index or offset
    offset = wordRange.upperBound
} while true



// Initialize the tagger
let tagger = NLTagger(tagSchemes: [.lexicalClass])
// Ignore whitespace and punctuation marks
let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation]
// Process the text for POS
tagger.string = text

// loop through all the tokens and print their POS tags
tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
    if let tag = tag{
        print("\(text[tokenRange]): \(tag.rawValue)")
    }
    return true
}


// Initialize NLTagger with ".nameType" scheme for NER
let tagger = NLTagger(tagSchemes: [.nameType])
tagger.string = text
// Ignore Punctuation and Whitespace
let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
// Tags to extract
let tags: [NLTag] = [.personalName, .placeName, .organizationName]
// Loop over the tokens and print the NER of the tokens
tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
    if let tag = tag, tags.contains(tag) {
        print("\(text[tokenRange]): \(tag.rawValue)")
    }
    return true
}
 */
 
 // Sentiment Analysis
 // Set up our input
 let input = "Naples is a nice city, not that good but good enough."

 // Feed it into the NaturalLanguage framework
 let tagger = NLTagger(tagSchemes: [.sentimentScore])
 tagger.string = input

 // Ask for the results
 let sentiment = tagger.tag(at: input.startIndex, unit: .paragraph, scheme: .sentimentScore).0

 // Read the sentiment back and print it
 let score = Double(sentiment?.rawValue ?? "0") ?? 0

 // Print the right smiley based on sentiment
 if score == 0{
     print("🙂")
 }
 else if score < 0{
     print("😢")
 }
 else {
     print("😁")
 }

 // Print the final sentiment score
 print("The sentiment score is: \(score)")

// Find similar words based on embedding
func embedCheck(word: String){
    // Extract the language type
    let lang = NLLanguageRecognizer.dominantLanguage(for: word)
    // Get the OS embeddings for the given language
    let embedding = NLEmbedding.wordEmbedding(for: lang!)
    
    // Find the 5 words that are nearest to the input word based on the embedding
    let res = embedding?.neighbors(for: word, maximumCount: 5)
    // Print the words
    print(res ?? [])
}

// Find words similar to cheese
embedCheck(word: "cheese")

*/
