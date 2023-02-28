//
//  Games.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 22/02/23.
//

import Foundation
import CoreML


struct Game: Codable, Identifiable {

    let id : Int
    let first_release_date : Int?
    let game_modes : [GameMode]?
    let genres : [Genre]?
    let keywords : [KeyWord]?
    let name : String
    let platforms : [Platform]?
    let similar_games : [SimilarGame]?
    
    
}

struct GameMode : Codable {
    let id : Int
    let name : String
}

struct Genre : Codable {
    let id : Int
    let name : String
}

struct KeyWord : Codable {
    let id: Int
    let name: String
}

struct Platform : Codable {
    let id : Int
    let name : String
}

struct SimilarGame : Codable {
    let id : Int
    let name : String
}

class MLString: MLFeatureProvider {
    let text: String
    var featureNames: Set<String>
    
    init(text: String) {
        self.text = text
        featureNames = []
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        let value = MLFeatureValue(string: text)
        return value
    }
}
