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
       // Message(botR: true, t: "Ciao a te")
    ]
    @State var text = ""
    @State var lastBotResponse = ""
    
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
                                     .foregroundColor(Color(uiColor: .systemGray6))
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(uiColor: .systemGray6))
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
                                        Text(messages.last! == message && message.isBotResponse() ? text : message.getText())
                                            .id(message.id)
                                            .padding()
                                            .padding(.horizontal)
                                            .font(Font.custom("RetroGaming", size: 16))
                                            .foregroundColor(Color(uiColor: .systemGray6))
                                            .background(Color(uiColor: .white))
                                            .lineLimit(nil)
                                            .clipShape(MessageBox())
                                            .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 2))
                                    }
                                    .frame( maxWidth: global_width*0.7, maxHeight: .infinity,alignment: message.isBotResponse() ? .leading : .trailing) // max message expansion
                                    .padding(message.isBotResponse() ? .leading : .trailing, global_width * 0.015)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: message.isBotResponse() ? .leading : .trailing )
                                .padding(.top, global_width*0.015)
                                
                            }
                            .onChange(of: messages) { newValue in
                                reader.scrollTo(messages.last!.id)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.top)
                        
                        
                    }
        
                    HStack{
                        TextField("", text: $textFieldValue)
                            .padding(.horizontal, global_width*0.05)
                            .padding(.vertical)
                            .font(Font.custom("RetroGaming", size: 17))
                            .foregroundColor(.black)
                            .frame(maxWidth: global_width*0.8)
                            .background(
                                Text("Type here...")
                                    .font(Font.custom("RetroGaming", size: 17))
                                    .frame(maxWidth: global_width*0.8, alignment: .leading)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, global_width*0.05)
                                    .padding(.vertical)
                                    .opacity(textFieldValue.isEmpty ? 1.0 : 0.0)
                            )
                            .disabled(messages.last != nil ? !(messages.last?.isBotResponse())!: false)
                      
                        Button {
                            if !textFieldValue.isEmpty {
                                submit()
                            }
                        } label: {
                            ZStack{
                                Image(systemName: textFieldValue.isEmpty ? "mic.fill" : "paperplane.fill" )
                                    .foregroundColor(Color(uiColor: .systemGray6))
                            }
                            .frame(width: global_width*0.1, height: global_width*0.1, alignment: .center)
                            .scaleEffect(1.5)
                        }
                        
                        
                    }
                    .frame(maxWidth: global_width, maxHeight: global_height * 0.08, alignment: .center)
                    .background(.white)
                    .clipped()
                    .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                    .clipShape(MessageBox())
                    .background(Color("BgColor"))
                
                    
                }
                .frame(maxWidth: .infinity, maxHeight: global_height, alignment: .bottom)
                
                
            }
        }
        
        
    }
    
    func typeWriter(at position: Int = 0) {
            if position == 0 {
                text = ""
            }
            if position < lastBotResponse.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    text.append(lastBotResponse[position])
                    typeWriter(at: position + 1)
                }
            }
        }
    
    func submit(){
        messages.append(Message(botR: false, t: textFieldValue))
        lastBotResponse = ""
        
        DispatchQueue.global(qos:.userInteractive).async {
            let message = messages.last?.getText() ?? ""
            let response = searchKeyword(keywords: recommender.get_tokens(text: message), games: games)
            lastBotResponse = response
            typeWriter()
            messages.append(Message(botR: true, t: response))
        }
       
        
        textFieldValue = ""
    }
    
    struct Chat_Preview: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }
}
