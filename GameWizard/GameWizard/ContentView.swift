//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI


let height = UIScreen.main.bounds.height
let width  = UIScreen.main.bounds.width

var testJSON = Post()

struct ContentView: View {
    
    @State var textFieldValue : String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("BgColor"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack{
                Button {
                    callAPI()
                } label: {
                    Text("Click here to import the Steam Library")
                        .font(.system(size: 20))
                }
                TextField("Type Here...", text: $textFieldValue)
                    .frame(maxWidth: width * 0.85, maxHeight: height * 0.02)
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .submitLabel(.send)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: height, alignment: .bottom)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
