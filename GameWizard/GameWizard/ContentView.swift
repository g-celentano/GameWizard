//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI

var testJSON = Post()
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button {
                callAPI()
            } label: {
                Text("Click here to import the Steam Library")
                    .font(.system(size: 20))
            }
    
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
