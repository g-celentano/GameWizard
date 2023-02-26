//
//  GameWizardApp.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI

@main
struct GameWizardApp: App {
    @StateObject private var gamesController = MyGamesDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, gamesController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
