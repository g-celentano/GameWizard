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
    
    @State var userBoxes : [CGSize] = []
    @State var botBoxes : [CGSize] = []
    
    @State var textFieldValue : String = ""
    @State var botResponse : String = ""
    @State var lastMexWidt : Double = 0.0
    @State var messages : [Message] = [
        Message(botR: false, t: "Ciao "),
        Message(botR: true, t: "Ciao a te")
    ]
    
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
                ScrollViewReader{ reader in
                    ScrollView{
                        
                        
                        ForEach(messages){ message in
                           
                            HStack {
                                HStack{
                                   
                                    //Text(messages.last == message && message.isBotResponse() && lastMexWidt < global_width*0.4 ? "" : message.getText() )
                            
                                    Text(message.getText())
                                        .id(message.id)
                                        .fixedSize()
                                        .font(Font.custom("RetroGaming", size: 16))
                                        .padding()
                                        .background(.white)
                                        .lineLimit(nil)
                                        .clipShape(MessageBox())
                                        .overlay(MessageBox()
                                                    .stroke(.black, lineWidth: 2))
                                    
                                        
                                
                                
                                    
                                        
                                }
                                .frame( maxWidth: global_width*0.7,minHeight: global_height*0.05, maxHeight: .infinity,alignment: message.isBotResponse() ? .leading : .trailing) // max message expansion
                                .onChange(of: messages) { newValue in
                                    reader.scrollTo(message.id)
                                }
                                .padding(message.isBotResponse() ? .leading : .trailing, global_width * 0.02)
                                
                            }
                            .frame(maxWidth: global_width*0.9, alignment: message.isBotResponse() ? .leading : .trailing )
                            
                        }
                        
                        
                    }
                    .frame(maxWidth: global_width, maxHeight: .infinity, alignment: .bottom)
                    .padding()
                    
                    
                }
                
                
    
                HStack{
                    
                        
                    TextField("Type Here...", text: $textFieldValue)
                        //.submitLabel(.send)
                        .padding(.leading)
                        .font(Font.custom("RetroGaming", size: 17))
                        .frame(maxWidth: global_width*0.8, maxHeight: global_height*0.05)
                        //.onSubmit(submit)
                  
                    Button {
                        if !textFieldValue.isEmpty {
                            submit()
                        }
                    } label: {
                        ZStack{
                            Image(systemName: textFieldValue.isEmpty ? "mic.fill" : "paperplane.fill" )
                                .foregroundColor(.white)
                        }
                        .frame(width: global_width*0.1, height: global_width*0.1, alignment: .center)
                        .background(.blue)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                    
                    
                }
                
                .frame(maxWidth: global_width*0.98, maxHeight: global_height * 0.07, alignment: .center)
                .background(.white)
                .clipped()
                .overlay(MessageBox().stroke(.black, lineWidth: 5))
                .clipShape(MessageBox())
                
               // .cornerRadius(18)
               // .padding(.vertical)
                
                .background(Color("BgColor"))
            
                
            }
            .frame(maxWidth: .infinity, maxHeight: global_height, alignment: .bottom)
            
            
        }
        
        
    }
    func submit(){
        lastMexWidt = 0.0
        messages.append(Message(botR: false, t: textFieldValue))
        
        print(textFieldValue.widthOfString(usingFont:UIFont(name:"RetroGaming", size: 16)!))
        print(global_height*0.05)
        lastMexWidt = global_width * 0.05
        
        //let response = recommender.get_sentiment(text: textFieldValue)
        //messages.append(Message(botR: true, t: response))
        
        /*
        let tokens = recommender.get_tokens(text: textFieldValue) 
        let response = searchKeyword(keywords: tokens, games: games)
        if response != nil{
            messages.append(Message(botR: true, t: response?.name ?? "Nothing found"))
        }
        
        */
        /*DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { // used to replicate response time
            
            withAnimation {
                lastMexWidt = global_width * 0.4
            }
            
        })*/
        textFieldValue = ""
        
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
