//
//  chat.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI

enum Field: Hashable {
        case input
        case none
    }

struct ChatView: View {
    @State var textFieldValue : String = ""
    @State var messages : [Message] = [
        //Message(botR: false, t: "Ciao "),
        //Message(botR: true, t: "Ciao a te")
    ]
    @State var text: String = ""
    @State var lastBotResponse: String = ""
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var already_suggested : FetchedResults<AlreadySuggested>
    @FetchRequest(sortDescriptors: []) var localGames : FetchedResults<MyGame>
    @State var firstChat: Bool = true
    @FocusState var textFieldFocus : Field?
    
    @AppStorage("bg") var bg_color_storage : String = "BgColor"
    @State var bgValue = "BgColor"
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(bgValue)
                    .ignoresSafeArea(.all)
                
                VStack{
                    HStack{
                        NavigationLink(destination: Lists()) {
                            HStack{
                                Spacer()
                                if bgValue == "BgColor" {
                                    Image("cdrom")
                                        .foregroundColor(Color(uiColor: .systemGray6))
                                        .scaleEffect(0.3)
                                } else {
                                    Image("Stemma")
                                        .foregroundColor(Color(uiColor: .systemGray6))
                                        .scaleEffect(0.3)
                                }
                            }.frame(width: global_width*0.1,height: global_width*0.1,alignment: .center)
                         }
                         .padding()
                         .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: global_height*0.01, alignment: .trailing)
                    
                    if bgValue == "BgColor" {
                        Image("gattomagico")
                            .frame(width: global_width, height: global_height*0.2)
                            .scaleEffect(2)
                        
                    } else {
                        Image("ciuccio")
                            .frame(width: global_width, height: global_height*0.2)
                            .scaleEffect(2)
                            .onTapGesture {
                                bgValue = "BgColor"
                                bg_color_storage = "BgColor"
                            }
                    }
                        
                    
                    
                        ScrollView{
                            ScrollViewReader { reader in
                                ForEach(messages){ message in
                                    HStack {
                                        HStack{
                                            Text(messages.last! == message && message.isBotResponse() ? text : message.getText())
                                                .messageLayout()
                                                .id(message.id)
                                                .contextMenu{
                                                    Group{
                                                        ForEach(message.getGames()){ g in
                                                            Button{
                                                                let localGamesNames = localGames.filter { myG in
                                                                    myG.gameName == g.name
                                                                }.last
                                                                if localGamesNames == nil {
                                                                    let newGame = MyGame(context: moc)
                                                                    newGame.id = UUID()
                                                                    newGame.gameName = g.name
                                                                    for key in g.keywords! {
                                                                        newGame.keywords?.append(key.name)
                                                                    }
                                                                    for genre in g.genres! {
                                                                        newGame.genres?.append(genre.name)
                                                                    }
                                                                    try? moc.save()
                                                                }
                                                                
                                                            } label:{
                                                                Text(g.name.withCString{
                                                                        String(format : NSLocalizedString("save %s", comment: ""), $0)
                                                                    })
                                                            }
                                                        }
                                                    }
                                                }
                                            
                                        }
                                        .frame(maxWidth: global_width*0.7, maxHeight: .infinity,alignment: message.isBotResponse() ? .leading : .trailing) // max message expansion
                                        .padding(message.isBotResponse() ? .leading : .trailing, global_width * 0.015)
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: message.isBotResponse() ? .leading : .trailing )
                                    .padding(.top, global_width*0.015)
                                    
                                }
                                .onChange(of: messages.count) { _ in
                                    withAnimation(.linear){
                                            reader.scrollTo(messages.last, anchor: .bottom)
                                        }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.top)
                        
        
                    HStack{
                        TextField("", text: $textFieldValue)
                            .senderLayout(textFieldValue, placeholder: NSLocalizedString("Type here...", comment: ""))
                            .disabled(messages.last != nil ? !(messages.last!.getText() == text) : false)
                            .focused($textFieldFocus, equals : .input)
                      
                        Button {
                            if !textFieldValue.isEmpty {
                                submit()
                            }
                        } label: {
                            VStack{
                                Image("sendicon")
                                    .scaleEffect(0.15)
                            }
                            .frame(width: global_width*0.1, height: global_width*0.1)
                        }
                    }
                    .frame(maxWidth: global_width, maxHeight: global_height * 0.08, alignment: .center)
                    .padding(.horizontal)
                    .background(.white)
                    .clipped()
                    .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                    .clipShape(MessageBox())
                    .background(Color(bgValue))
                    .padding(.vertical)
                }
                .onTapGesture(perform: {
                    textFieldFocus = nil
                })
                .onAppear(perform: {
                    bgValue = bg_color_storage
                    if firstChat {
                        firstChat = false
                        lastBotResponse = ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            lastBotResponse = NSLocalizedString("mainChat_intro", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                        }
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: global_height, alignment: .bottom)
            }
        }
    }
    
    func typeWriter(at position: Int = 0) {
            if position == 0 {
                text = ""
            }
            if position < lastBotResponse.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.035) {
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
            print(message)
            if message != "Forza Napoli" {
                let botResponse = response_handler.getResponse(userMessage: message, already: already_suggested, context: moc)
                lastBotResponse = botResponse.message
                typeWriter()
                messages.append(Message(botR: true, t: lastBotResponse, games: botResponse.response_games))
            } else {
                if bgValue != "forzaNapoli" {
                    withAnimation(.linear(duration:1)) {
                        bgValue = "forzaNapoli"
                    }
                    bg_color_storage = "forzaNapoli"
                    
                    print(bg_color_storage)
                    lastBotResponse = NSLocalizedString("Secret", comment: "")
                    typeWriter()
                    messages.append(Message(botR: true, t: lastBotResponse))
                } else {
                    lastBotResponse = NSLocalizedString("SecretAlready", comment: "")
                    typeWriter()
                    messages.append(Message(botR: true, t: lastBotResponse))
                }
                
            }
             
        }
        textFieldValue = ""
    }
    
    struct Chat_Preview: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }
}
