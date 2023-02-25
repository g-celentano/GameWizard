//
//  chat.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI


struct ChatView: View {
    
    @State var userBoxes : [CGSize] = []
    @State var botBoxes : [CGSize] = []
    
    @State var textFieldValue : String = ""
    @State var botResponse : String = ""
    @State var lastMexWidt : Double = 0.0
    @State var messages : [Message] = [
        //Message(botR: false, t: "Ciao "),
        //Message(botR: true, t: "Ciao a te")
    ]
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color("BgColor")
                    .ignoresSafeArea(.all)
                
                VStack{
                    /*Button {
                     callAPI()
                     } label: {
                     Text("Click here to import the Steam Library")
                     .font(.system(size: 20))
                     }*/
                    HStack{
                        NavigationLink(destination: MyGames()) {
                            HStack{
                                 Text("My games")
                                     .font(Font.custom("RetroGaming", size: 18))
                                     .foregroundColor(.black)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }.frame(alignment: .center)
                         }
                         .padding()
                         .padding(.top)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: global_height*0.01, alignment: .trailing)
                    ScrollViewReader{ reader in
                        ScrollView{
                            
                            
                            ForEach(messages){ message in
                               
                                HStack {
                                    HStack{
                                       
                                        //Text(messages.last == message && message.isBotResponse() && lastMexWidt < global_width*0.4 ? "" : message.getText() )
                                        Text(message.getText())
                                            .id(message.id)
                                            .padding()
                                            .font(Font.custom("RetroGaming", size: 16))
                                            .foregroundColor(.black)
                                            .background(.white)
                                            .lineLimit(nil)
                                            .clipShape(MessageBox())
                                            .overlay(MessageBox().stroke(.black, lineWidth: 3))
                                    }
                                    .frame( maxWidth: global_width*0.7, maxHeight: .infinity,alignment: message.isBotResponse() ? .leading : .trailing) // max message expansion
                                    .onChange(of: messages) { newValue in
                                        reader.scrollTo(message.id)
                                    }
                                    .padding(message.isBotResponse() ? .leading : .trailing, global_width * 0.015)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: message.isBotResponse() ? .leading : .trailing )
                                .padding(.top, global_width*0.015)
                                
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.top)
                        
                        
                    }
                    
                    
        
                    HStack{
                        
                            
                        TextField("Type Here...", text: $textFieldValue)
                            //.submitLabel(.send)
                            .padding(.horizontal)
                            .font(Font.custom("RetroGaming", size: 17))
                            .foregroundColor(.black)
                            .frame(maxWidth: global_width*0.8, maxHeight: global_height*0.05)
                            //.onSubmit(submit)
                      
                        Button {
                            if !textFieldValue.isEmpty {
                                submit()
                            }
                        } label: {
                            ZStack{
                                Image(systemName: textFieldValue.isEmpty ? "mic.fill" : "paperplane.fill" )
                                    .foregroundColor(.black)
                            }
                            .frame(width: global_width*0.1, height: global_width*0.1, alignment: .center)
                            .scaleEffect(1.2)
                        }
                        
                        
                    }
                    .frame(maxWidth: global_width, maxHeight: global_height * 0.08, alignment: .center)
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
        
        
    }
    func submit(){
        lastMexWidt = 0.0
        messages.append(Message(botR: false, t: textFieldValue))
        
        lastMexWidt = global_width * 0.05
        
        let response = searchKeyword(keywords: recommender.get_tokens(text: textFieldValue), games: games)
        messages.append(Message(botR: true, t: response))
        
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
    
    struct Chat_Preview: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }
}