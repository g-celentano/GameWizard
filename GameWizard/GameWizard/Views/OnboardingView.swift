//
//  OnboardingView.swift
//  GameWizard
//
//  Created by Letterio Ugo Cangiano on 02/03/23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("currentView") var currentView = 1
    @State var textFieldValue : String = ""
    @State var messages : [Message] = [
        //Message(botR: false, t: "Ciao "),
        //Message(botR: true, t: "Ciao a te")
    ]
    
    @State var text = ""
    @State var lastBotResponse = ""
    @FetchRequest(sortDescriptors: []) var localGames : FetchedResults<MyGame>
    @FetchRequest(sortDescriptors: []) var already: FetchedResults<AlreadySuggested>
    
    
    
    @Environment(\.managedObjectContext) var moc
    @State var noInput = true
    @State var selectedGame : String = ""
    
    @State var allowInput = false
    @State var inputHeightBool = false
    
    var body: some View {
       ZStack {
            Color("BgColor")
                .ignoresSafeArea(.all)
            
            VStack{
                
                Image("gattomagico")
                    .frame(width: global_width, height: global_height*0.2)
                    .scaleEffect(2)
                
                ScrollViewReader{ reader in
                    ScrollView{
                        ForEach(messages){ message in
                            HStack {
                                HStack{
                                    Text(messages.last! == message && message.isBotResponse() ? text : message.getText())
                                        .id(message.id)
                                        .messageLayout()
                                        .contextMenu{
                                            Group{
                                                ForEach(message.getGames()){ g in
                                                    
                                                    Button{
                                                        lastBotResponse = NSLocalizedString("find_saved_games_onboarding", comment: "")
                                                        typeWriter()
                                                        messages.append(Message(botR: true, t: lastBotResponse))
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 8){
                                                            lastBotResponse = NSLocalizedString("are you ready", comment: "")
                                                            typeWriter()
                                                            messages.append(Message(botR: true, t: lastBotResponse))
                                                            withAnimation(.easeIn){
                                                                textFieldValue = "start"
                                                            }
                                                        }
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
                                .frame( maxWidth: global_width*0.7, maxHeight: .infinity,alignment: message.isBotResponse() ? .leading : .trailing) // max message expansion
                                .padding(message.isBotResponse() ? .leading : .trailing, global_width * 0.015)
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: message.isBotResponse() ? .leading : .trailing )
                            .padding(.top, global_width*0.015)
                            
                        }
                        
                        
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation(.linear(duration: 0.0005)){
                            let last = messages.last
                            reader.scrollTo(last!.id, anchor: .top)
                            }
                    }
                    .onChange(of: text) { _ in
                        withAnimation(.linear(duration: 0.0005)){
                            let last = messages.last
                            reader.scrollTo(last!.id, anchor: .top)
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.top)
                    
                    
                }
    
                HStack{
                    TextField("", text: $textFieldValue)
                        .font(Font.custom("RetroGaming", size: textFieldValue == "start" ? global_width*0.08:global_width*0.042))
                        .foregroundColor(Color(uiColor: textFieldValue == "start" ? .systemRed : .systemGray6 ))
                        .senderLayout(textFieldValue, placeholder: NSLocalizedString("Type here...", comment: ""))
                        .disabled(messages.last != nil ? !(messages.last!.getText() == text) : false)
                        .disabled(noInput)
                        .disabled(textFieldValue == "start")
                        .multilineTextAlignment(textFieldValue == "start" ? .center : .leading)
                        
                    
                  
                    Button {
                        if !textFieldValue.isEmpty {
                            submit()
                        }
                    } label: {
                        VStack{
                            //Image("Cat_Paw_2")
                            Image("sendicon")
                                .scaleEffect(0.15)
                               // .padding(.bottom)
                        }
                        .frame(width: textFieldValue == "start" ? 0.0 :  global_width*0.1, height:textFieldValue == "start" ? 0.0 : global_width*0.1)
                        .opacity(textFieldValue == "start" ? 0.0 : 1.0)
                    }
                    .disabled(textFieldValue == "start")
                    
                    
                }
                .frame(maxWidth: allowInput ?  global_width : 0.0, maxHeight: global_height * 0.07, alignment: .center)
                .padding(.horizontal)
                .background(.white, in: MessageBoxV2BG())
                .clipped()
                .overlay(MessageBoxV2Border().stroke(Color(uiColor: .systemGray6), lineWidth: 5.5))
                .background(Color("BgColor"))
                .opacity(inputHeightBool ? 1.0 : 0.0)
                .onTapGesture {
                    if textFieldValue == "start" {
                            currentView = 2
                    }
                }
            
                
            }
            .onAppear(perform: {
                lastBotResponse = ""
                text = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    lastBotResponse = NSLocalizedString("welcome_first_message_onboarding", comment: "")
                    typeWriter()
                    messages.append(Message(botR: true, t: lastBotResponse))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 9){
                    lastBotResponse = NSLocalizedString("welcome_second_message_onboarding", comment: "")
                    typeWriter()
                    messages.append(Message(botR: true, t: lastBotResponse))
                    noInput = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                        inputHeightBool = true
                        withAnimation(.easeInOut(duration: 1.5)){
                            allowInput = true
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 19.5){
                    lastBotResponse = NSLocalizedString("welcome_third_message_onboarding", comment: "")
                    typeWriter()
                    messages.append(Message(botR: true, t: lastBotResponse))
                    noInput = false
                    
                }
            })
            .frame(maxWidth: .infinity, maxHeight: global_height, alignment: .bottom)
            
            
        }
    }
    
    func typeWriter(at position: Int = 0, appendNew : Bool = false, textToAppend : String = "") {
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
            let whitespaces = message.split(separator: " ")
            
            
            if whitespaces.count > 2{
                if message.contains(NSLocalizedString("games", comment: "")) {
                    let newMessage = message.replacingOccurrences(of: NSLocalizedString("games", comment: ""), with: "")
                    let response_games = searchKeywords(keywords: recommender.get_keywords(text: newMessage), games: games, alreadySuggested: already)
                    
                    
                    if !response_games.isEmpty {
                       
                        var botRes = NSLocalizedString("Games found intro", comment: "")
                        var games_in_response : [Game] = []
                        for g in response_games{
                            if g == response_games.last! {
                                botRes.append(" ✰ \(g!)")
                            } else {
                                botRes.append(" ✰ \(g!) \n")
                            }
                            let giuoco = games.filter { gioco in
                                gioco.name == g
                            }
                            games_in_response.append(giuoco[0])
                            
                        }
                    
                        lastBotResponse = botRes
                        typeWriter()
                        messages.append(Message(botR: true, t: botRes, games: games_in_response))
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                            lastBotResponse = NSLocalizedString("save_instructions", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                        }
                        
                        } else {
                            lastBotResponse = NSLocalizedString("no game", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                        }
                    } else if message.contains(NSLocalizedString("game", comment: "")) {
                        let newMessage = message.replacingOccurrences(of: NSLocalizedString("game", comment: ""), with: "")
                        let response_games = searchKeyword(keywords: recommender.get_keywords(text: newMessage), games: games, alreadySuggested: already)
                        
                        if !(response_games?.isEmpty ?? false) {
                            let botRes = response_games!.withCString {
                                String(format: NSLocalizedString("I found %s", comment: ""), $0)
                            }
                            let game = games.filter { g in
                                g.name == response_games!
                            }
                            lastBotResponse = botRes
                            typeWriter()
                            messages.append(Message(botR: true, t: botRes, games: [game[0]]))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                                lastBotResponse = NSLocalizedString("save_instructions", comment: "")
                                typeWriter()
                                messages.append(Message(botR: true, t: lastBotResponse))
                            }
                            
                            }
                        else {
                            lastBotResponse = NSLocalizedString("no game", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                        }
                
                        
                    } else {
                        let response_games = searchKeyword(keywords: recommender.get_keywords(text: message), games: games, alreadySuggested: already)
                        
                        if !(response_games?.isEmpty ?? false) {
                            let botRes = response_games!.withCString {
                                String(format: NSLocalizedString("I found %s", comment: ""), $0)
                            }
                            let game = games.filter { g in
                                g.name == response_games!
                            }
                            lastBotResponse = botRes
                            typeWriter()
                            messages.append(Message(botR: true, t: botRes, games: [game[0]]))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                                lastBotResponse = NSLocalizedString("save_instructions", comment: "")
                                typeWriter()
                                messages.append(Message(botR: true, t: lastBotResponse))
                            }
                        }
                            
                        else {
                            lastBotResponse = NSLocalizedString("no game", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                        }
                
                    }

            } else {
                lastBotResponse = NSLocalizedString("Sorry I did not understand", comment: "")
                typeWriter()
                messages.append(Message(botR: true, t: lastBotResponse))
            }
        }
        textFieldValue = ""
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
