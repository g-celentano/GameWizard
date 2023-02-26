//
//  MyGamesDataController.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 26/02/23.
//

import CoreData
import Foundation

class MyGamesDataController: ObservableObject {
    let container = NSPersistentContainer(name: "MyGames")
    
    init() {
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
            
        }
    }
    
}
