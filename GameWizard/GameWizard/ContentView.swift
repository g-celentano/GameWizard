//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI

var cartaMoneta = "Oro"

var dioCane = "🐶"

var roberto = "bau"

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
