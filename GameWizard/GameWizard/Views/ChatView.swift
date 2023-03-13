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
    @State var games_in_response : [Game] = []
    @FocusState var textFieldFocus : Field?
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color("BgColor")
                    .ignoresSafeArea(.all)
                
                VStack{
                    HStack{
                        NavigationLink(destination: Lists()) {
                            HStack{
                                 /*Text("My games")
                                     .font(Font.custom("RetroGaming", size: 18))
                                     .foregroundColor(Color(uiColor: .systemGray6))*/
                                Image("cdrom")
                                    .foregroundColor(Color(uiColor: .systemGray6))
                                    .scaleEffect(0.45)
                                    .padding(.trailing, -global_width*0.06)
                                    .padding(.top)
                                
                               /* Image(systemName: "chevron.right")
                                    .foregroundColor(Color(uiColor: .systemGray6))*/
                            }.frame(alignment: .center)
                         }
                         .padding()
                         .padding(.top)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: global_height*0.01, alignment: .trailing)
                    
                    Image("gattomagico")
                        .frame(width: global_width, height: global_height*0.2)
                        .scaleEffect(2)
                    
                    
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
                                                                Text(
                                                                    g.name.withCString{
                                                                        String(format : NSLocalizedString("save %s", comment: ""), $0)
                                                                    }
                                                                )
                                                                
                                                                
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
                                //Image("Cat_Paw_2")
                                Image("sendicon")
                                    .scaleEffect(0.15)
                                   // .padding(.bottom)
                                
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
                    .background(Color("BgColor"))
                    .padding(.vertical)
                
                    
                }
                .onTapGesture(perform: {
                    textFieldFocus = nil
                })
                .onAppear(perform: {
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
            let whitespaces = message.split(separator: " ")
            
            
            if whitespaces.count > 2{
                if message.contains(NSLocalizedString("games", comment: "")) {
                    let newMessage = message.replacingOccurrences(of: NSLocalizedString("games", comment: ""), with: "")
                    let response_games = searchKeywords(keywords: recommender.get_keywords(text: newMessage), games: games, alreadySuggested: already_suggested)
                    
                    
                    if !response_games.isEmpty {
                        //var actualResponse : [String] = []
                        var suggNames : [String] = []
                        var games_in_response : [Game] = []
                        
                        if !already_suggested.isEmpty{
                            for already in already_suggested {
                                suggNames.append(already.gameName!)
                            }
                        }
                        
                        for response in response_games {
                            if !suggNames.contains(response!){
                                //actualResponse.append(response!)
                                let suggested = AlreadySuggested(context:moc)
                                let suggestedGame = games.filter({ game in
                                    game.name == response
                                })
                                suggested.gameName = suggestedGame[0].name
                                for key in suggestedGame[0].keywords! {
                                    suggested.keywords?.append(key.name)
                                }
                                for genre in suggestedGame[0].genres!{
                                    suggested.genres?.append(genre.name)
                                }
                                for similar in suggestedGame[0].similar_games!{
                                    suggested.similar_games?.append(similar.name)
                                }
                                try? moc.save()
                                 
                            }
                        }
                            var botRes = NSLocalizedString("Games found intro", comment: "")
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
                             
                            
                        } else {
                            lastBotResponse = NSLocalizedString("no game", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                             
                        }
                    } else if message.contains(NSLocalizedString("game", comment: "")) {
                        let newMessage = message.replacingOccurrences(of: NSLocalizedString("game", comment: ""), with: "")
                        let response_games = searchKeyword(keywords: recommender.get_keywords(text: newMessage), games: games, alreadySuggested: already_suggested)
                        
                        if !(response_games?.isEmpty ?? false) {
                            var suggNames : [String] = []
                            if !already_suggested.isEmpty{
                                for already in already_suggested {
                                    suggNames.append(already.gameName!)
                                }
                            }
                            if !suggNames.contains(response_games!){
                                let suggested = AlreadySuggested(context:moc)
                                let suggestedGame = games.filter({ game in
                                    game.name == response_games
                                })
                                suggested.gameName = suggestedGame[0].name
                                for key in suggestedGame[0].keywords! {
                                    suggested.keywords?.append(key.name)
                                }
                                for genre in suggestedGame[0].genres!{
                                    suggested.genres?.append(genre.name)
                                }
                                for similar in suggestedGame[0].similar_games!{
                                    suggested.similar_games?.append(similar.name)
                                }
                                try? moc.save()
                            }
                            let botRes = response_games!.withCString {
                                String(format: NSLocalizedString("I found %s", comment: ""), $0)
                            }
                            let game = games.filter { g in
                                g.name == response_games!
                            }
                            
                            lastBotResponse = botRes
                            typeWriter()
                            messages.append(Message(botR: true, t: botRes, games: [game[0]]))
                             
                            }
                        else {
                            lastBotResponse = NSLocalizedString("no game", comment: "")
                            typeWriter()
                            messages.append(Message(botR: true, t: lastBotResponse))
                             
                        }
                
                        
                    } else {
                        let response_games = searchKeyword(keywords: recommender.get_keywords(text: message), games: games, alreadySuggested: already_suggested)
                        
                        if !(response_games?.isEmpty ?? false) {
                            let botRes = response_games!.withCString {
                                String(format: NSLocalizedString("I found %s", comment: ""), $0)
                            }
                            let game = games.filter { g in
                                g.name == response_games!
                            }
                            
                            lastBotResponse = botRes
                            typeWriter()
                            
                            var suggNames : [String] = []
                            if !already_suggested.isEmpty{
                                for already in already_suggested {
                                    suggNames.append(already.gameName!)
                                }
                            }
                            if !already_suggested.isEmpty{
                                for already in already_suggested {
                                    suggNames.append(already.gameName!)
                                }
                            }
                            if !suggNames.contains(response_games!){
                                let suggested = AlreadySuggested(context:moc)
                                let suggestedGame = games.filter({ game in
                                    game.name == response_games
                                })
                                suggested.gameName = suggestedGame[0].name
                                for key in suggestedGame[0].keywords! {
                                    suggested.keywords?.append(key.name)
                                }
                                for genre in suggestedGame[0].genres!{
                                    suggested.genres?.append(genre.name)
                                }
                                for similar in suggestedGame[0].similar_games!{
                                    suggested.similar_games?.append(similar.name)
                                }
                                try? moc.save()
                            }
                            messages.append(Message(botR: true, t: botRes, games: [game[0]]))
                             
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
    
    struct Chat_Preview: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }
}
