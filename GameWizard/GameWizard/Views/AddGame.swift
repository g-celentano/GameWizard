//
//  AddGame.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 25/02/23.
//

import SwiftUI



struct AddGame : View{
 
    @FetchRequest(sortDescriptors: []) var myGames2 : FetchedResults<MyGame>
    @Environment(\.managedObjectContext) var moc
    @State var gameName : String = ""
    @State var genres : [String] = []
    @State var keywords : [String] = []
    @Environment(\.dismiss) var dismiss
    @State var contains = false
    @State var nameGood = false
    @FocusState var gameNameFocus : Field?
    
    @AppStorage("bg") var bg_color_storage : String = "BgColor"
    @State var bgValue = "BgColor"
    
    
    
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: "RetroGaming", size: 32)!,
            .foregroundColor : UIColor.systemGray6,
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "RetroGaming", size: 18)!,
            .foregroundColor : UIColor.white
        ]
        
        
    }
    
   
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(bgValue)
                    .ignoresSafeArea(.all)
                
                VStack{
                        TextField("", text: $gameName)
                            .senderLayout(gameName, placeholder: NSLocalizedString("Game Name", comment: ""))
                            .padding(.horizontal, global_width*0.05)
                            .background(.white, in: MessageBoxV2BG())
                            .clipped()
                            .overlay(MessageBoxV2Border().stroke(Color(uiColor: .systemGray6), lineWidth: 4.5))
                            //.overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                            //.clipShape(MessageBox())
                            .focused($gameNameFocus, equals: .input)
                        
                        /*
                        HStack{
                            Text("Game Genres")
                                .font(Font.custom("RetroGaming", size: 24))
                                .foregroundColor(Color(uiColor: .systemGray6))
                            Spacer()
                            Button{
                                if genres.last != nil {
                                    if !genres.last!.isEmpty {
                                        genres.append("")
                                    }
                                } else {
                                    genres.append("")
                                }
                                
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(Color(uiColor: .systemGray6))
                                    .scaleEffect(1.25)
                            }
                        }
                        .frame(maxWidth: global_width*0.9)
                        ScrollView{
                            ForEach(genres.indices, id : \.self){ index in
                                TextField("", text: $genres[index])
                                    .submitLabel(.done)
                                    .padding(.horizontal, global_width*0.05)
                                    .font(Font.custom("RetroGaming", size: 17))
                                    .foregroundColor(Color(uiColor: .systemGray6))
                                    .frame(maxWidth: global_width*0.9)
                                    .background(
                                        Text("Game Genre")
                                            .font(Font.custom("RetroGaming", size: 17))
                                            .frame(maxWidth: global_width*0.8, maxHeight: global_height*0.05, alignment: .leading)
                                            .foregroundColor(Color(uiColor: .systemGray))
                                            .padding(.horizontal, global_width*0.05)
                                            .opacity(genres[index].isEmpty ? 1.0 : 0.0)
                                    )
                                    .padding(.vertical)
                                    .background(.white)
                                    .clipped()
                                    .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                                    .clipShape(MessageBox())
                                
                            }
                        }
                        .frame(maxWidth: global_width*0.9, maxHeight: .infinity)
                         */
                    HStack{
                        Text(NSLocalizedString("Suggestions", comment: ""))
                            .font(Font.custom("RetroGaming", size: 24))
                            .foregroundColor(Color(uiColor: .systemGray6))
                        Spacer()
                    }
                    .frame(maxWidth: global_width*0.9)
                    
                    let suggestions = gameName != "" ? games.filter({ game in
                        game.name.lowercased().contains(gameName.lowercased())}) : games
                    
                    ScrollView{
                        LazyVStack{
                            ForEach(suggestions){ game in
                                    Text(game.name)
                                        .frame(width:global_width*0.8, height: global_height*0.02)
                                            .messageLayout()
                                            .onTapGesture {
                                                let suggested = games.filter({ g in
                                                    g.name == game.name
                                                })[0]
                                                gameName = suggested.name
                                                if suggested.genres != nil{
                                                    for genre in suggested.genres! {
                                                        genres.append(genre.name)
                                                    }
                                                }
                                                if suggested.keywords != nil{
                                                    for key in suggested.keywords! {
                                                        keywords.append(key.name)
                                                    }
                                                }
                                            }
                                
                                }
                                .padding(.horizontal)
                            
                            }
                            .frame(maxWidth: global_width, maxHeight: .infinity)
                            
                        
                        }
                        .frame(maxWidth: global_width, maxHeight: .infinity)
                        .id(UUID())
                
                        
                    
                        
                        Button{
                            if nameGood && !contains{
                                let newGame = MyGame(context: moc)
                                newGame.id = UUID()
                                newGame.gameName = gameName
                                newGame.keywords = keywords
                                newGame.genres = genres
                                try? moc.save()
                                dismiss()
                            }
                        }label: {
                            Text(NSLocalizedString("Add", comment: ""))
                                .font(Font.custom("RetroGaming",size: 24))
                                .foregroundColor(Color(uiColor: .systemGray6) )
                                .frame(width: global_width*0.85)
                                .padding(.vertical)
                                .background(.white, in: MessageBoxV2BG())
                                .overlay(MessageBoxV2Border().stroke(Color(uiColor: .systemGray6), lineWidth: 5))
                                //.overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 5))
                                //.clipShape(MessageBox())
                                .opacity(nameGood && !contains ? 1.0 : 0.7)
                                .onChange(of: gameName) { newValue in
                                    contains = false
                                    nameGood = false
                                    
                                    for game in myGames2 {
                                        if game.gameName == gameName{
                                            contains = true
                                        }
                                    }
                                    for sugg in suggestions {
                                        if sugg.name == gameName{
                                            nameGood = true
                                        }
                                    }
                                }
                        }
                        
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                    
                /*let suggestions = games.filter({ game in
                    game.name.hasPrefix(gameName)
                })
                if gameName != "" && suggestions.count > 1 {
                    ScrollView{
                        ForEach(suggestions){ game in
                                Text(game.name)
                                    .font(Font.custom("RetroGaming", size: 14))
                                    .padding(.vertical)
                                    .onTapGesture {
                                        gameName = game.name
                                        for genre in game.genres! {
                                            genres.append(genre.name)
                                        }
                                    }
                        }
                    }
                    .id(UUID())
                    .frame(maxWidth: global_width*0.9, minHeight:0.0, maxHeight: global_height*0.3)
                    .background(Color(uiColor: .systemGray6))
                    .padding(.top, global_height*0.02)
                    
                }*/
               
                
                }
            .onAppear{
                bgValue = bg_color_storage
            }
            
            }
            .onTapGesture {
                gameNameFocus = nil
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(NSLocalizedString("Add a new game", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(uiColor: .systemGray6))
                            .scaleEffect(1.3)
                    }
                }
            }
            
        }
    
    
        
        struct AddGame_Preview : PreviewProvider {
            
            static var previews: some View{
                AddGame()
            }
        }
        
        
    
}
