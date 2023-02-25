//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI

extension String {
   func widthOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}


let global_height = UIScreen.main.bounds.height
let global_width  = UIScreen.main.bounds.width
let games : [Game] = load("games")
let recommender : Recommender = Recommender()

struct ContentView: View {
    
   
    var body: some View {
        ChatView()
    }
        struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
