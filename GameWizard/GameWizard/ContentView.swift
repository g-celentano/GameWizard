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
    @State var messages : [Message] = [
    Message(botResponse: false, text: "Ciao"),
    //Message(botResponse: true, text: "Ciao a te")
    ]
    @State var botting : Bool = false // used to altern messages on the left and on the right sides
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("BgColor"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack{
                /*Button {
                    callAPI()
                } label: {
                    Text("Click here to import the Steam Library")
                        .font(.system(size: 20))
                }*/
                ScrollView{
                    
                    ForEach(messages){message in
                        HStack {
                               HStack{
                                    Text( message.text )
                                        .lineLimit(nil)
                                        .font(.title3)
                                        .padding()
                                        .frame(minWidth: width*0.4 ,minHeight: height * 0.05,  alignment: .leading)
                                        .background(.white) // put custom bg
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // put custom bg
                               }
                               .frame(maxWidth: width*0.7, alignment: message.botResponse ? .leading : .trailing) // max message expansion
                        }
                        .frame(maxWidth: width*0.9, alignment: message.botResponse ? .leading : .trailing )
                    }
                    
                    
                }
                .frame(maxWidth: width, maxHeight: .infinity, alignment: .bottom)
                .padding()
                
                
                
                TextField("Type Here...", text: $textFieldValue)
                    .frame(maxWidth: width * 0.85, maxHeight: height * 0.02)
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .submitLabel(.send)
                    .onSubmit {
                        messages.append(Message(botResponse: botting, text: textFieldValue))
                        textFieldValue = ""
                        botting.toggle()
                    }
                    
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
