//
//  Searcher.swift
//  GameWizard
//
//  Created by Letterio Ugo Cangiano on 23/02/23.
//

import Foundation

func searchKeyword(keywords: [String], games: [Game]) -> String {
    var maxMatches = 0
    var matchedGame : Game?
    var index = 0
    var keyIndex = 0
    
    for game in games {
        var matches = 0
        if game.keywords != nil {
            for _ in game.keywords! {
                if keywords.contains(where: {
                    games[index].keywords![keyIndex].name.lowercased().contains($0.lowercased())
                })
                {
                    matches += 1
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
    
        return matchedGame?.name ?? "No game"

                                                
}
