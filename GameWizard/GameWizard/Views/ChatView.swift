//
//  chat.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI


struct ChatView: View {
    
    @State var textFieldValue : String = ""
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
                                        Text(message.getText())
                                            .id(message.id)
                                            .padding()
                                            .padding(.horizontal)
                                            .font(Font.custom("RetroGaming", size: 16))
                                            .foregroundColor(.black)
                                            .background(.white)
                                            .lineLimit(nil)
                                            .clipShape(MessageBox())
                                            .overlay(MessageBox().stroke(.black, lineWidth: 6))
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
                        
                        TextField("", text: $textFieldValue)
                            .padding(.horizontal, global_width*0.05)
                            .font(Font.custom("RetroGaming", size: 17))
                            .foregroundColor(.black)
                            .frame(maxWidth: global_width*0.8, maxHeight: global_height*0.05)
                            .background(
                                Text("Type here...")
                                    .font(Font.custom("RetroGaming", size: 17))
                                    .frame(maxWidth: global_width*0.8, maxHeight: global_height*0.05, alignment: .leading)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, global_width*0.05)
                                    .opacity(textFieldValue.isEmpty ? 1.0 : 0.0)
                            )
                      
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
                    .overlay(MessageBox().stroke(.black, lineWidth: 8))
                    .clipShape(MessageBox())
                    
                    .background(Color("BgColor"))
                
                    
                }
                .frame(maxWidth: .infinity, maxHeight: global_height, alignment: .bottom)
                
                
            }
        }
        
        
    }
    func submit(){
        messages.append(Message(botR: false, t: textFieldValue))
        
        
        let response = searchKeyword(keywords: recommender.get_tokens(text: textFieldValue), games: games)
        messages.append(Message(botR: true, t: response))
        
        /*
        let tokens = recommender.get_tokens(text: textFieldValue)
        let response = searchKeyword(keywords: tokens, games: games)
        if response != nil{
            messages.append(Message(botR: true, t: response?.name ?? "Nothing found"))
        }
        
        */
        textFieldValue = ""
        
        
    }
    
    struct Chat_Preview: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }
}
