//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI

let height = UIScreen.main.bounds.height
let width  = UIScreen.main.bounds.width


struct ContentView: View {
    
    @State var textFieldValue : String = ""
   
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("BgColor"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack{
                TextField("Type Here...", text: $textFieldValue)
                    .frame(maxWidth: width * 0.85, maxHeight: height * 0.02)
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .submitLabel(.send)
            }
            .frame(maxWidth: .infinity, maxHeight: height, alignment: .bottom)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
