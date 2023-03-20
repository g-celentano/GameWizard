//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI



let global_height = UIScreen.main.bounds.height
let global_width  = UIScreen.main.bounds.width
let games : [Game] = load("games")
let recommender : Recommender = Recommender()
let response_handler : ResponseHandler = ResponseHandler()

var totalViews = 1


struct ContentView: View {
   @AppStorage("currentView") var currentView = 1
    var body: some View {
        
        if currentView == 1 {
            OnboardingView()
        } else if currentView == 2 {
            ChatView()
        }
    }
    
    
        struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
