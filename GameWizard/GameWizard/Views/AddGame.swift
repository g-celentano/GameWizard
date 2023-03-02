//
//  AddGame.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 25/02/23.
//

import SwiftUI



struct AddGame : View{
 
    
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
    
    
    @FetchRequest(sortDescriptors: []) var myGames2 : FetchedResults<MyGame>
    @Environment(\.managedObjectContext) var moc
    @State var gameName : String = ""
    @State var genres : [String] = []
    @State var keywords : [String] = []
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color("BgColor")
                    .ignoresSafeArea(.all)
                
                VStack{
                        TextField("", text: $gameName)
                            .submitLabel(.done)
                            .padding(.horizontal, global_width*0.05)
                            .font(Font.custom("RetroGaming", size: 17))
                            .foregroundColor(Color(uiColor: .systemGray6))
                            .frame(maxWidth: global_width*0.9)
                            .background(
                                Text("Game Name")
                                    .font(Font.custom("RetroGaming", size: 17))
                                    .frame(maxWidth: global_width*0.9, alignment: .leading)
                                    .foregroundColor(Color(uiColor: .systemGray))
                                    .padding(.horizontal, global_width*0.05)
                                    .opacity(gameName.isEmpty ? 1.0 : 0.0)
                            )
                            .padding(.vertical)
                            .background(.white)
                            .clipped()
                            .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                            .clipShape(MessageBox())
                        
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
                        Text("Suggestions")
                            .font(Font.custom("RetroGaming", size: 24))
                            .foregroundColor(Color(uiColor: .systemGray6))
                        Spacer()
                    }
                    .frame(maxWidth: global_width*0.9)
                    
                    let suggestions = gameName != "" ?  games.filter({ game in
                        game.name.hasPrefix(gameName)}) : []
                        
                        ScrollView{
                                ForEach(suggestions){ game in
                                    LazyHStack{
                                        Text(game.name)
                                            .frame(width: global_width*0.9)
                                            .padding(.horizontal, global_width*0.05)
                                            .font(Font.custom("RetroGaming", size: 17))
                                            .foregroundColor(Color(uiColor: .systemGray6))
                                            .padding(.vertical)
                                            .background(.white)
                                            .clipped()
                                            .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                                            .clipShape(MessageBox())
                                            .onTapGesture {
                                                gameName = game.name
                                                for genre in game.genres! {
                                                    genres.append(genre.name)
                                                }
                                                for key in game.keywords! {
                                                    keywords.append(key.name)
                                                }
                                            }
                                    }
                                    
                                }
                            }.frame(maxWidth: global_width*0.9, maxHeight: .infinity)
                    
                        
                        Button{
                            var contains = false
                            for game in myGames2 {
                                if game.gameName == gameName && game.genres == genres{
                                    contains = true
                                }
                            }
                            
                            if suggestions.count <= 1 && suggestions.last!.name == gameName && !contains {
                                let newGame = MyGame(context: moc)
                                if contains == false {
                                    newGame.id = UUID()
                                    newGame.gameName = gameName
                                    newGame.keywords = keywords
                                    newGame.genres = genres
                                    try? moc.save()
                                    dismiss()
                                }
                            }
                        }label: {
                            Text("Add")
                                .font(Font.custom("RetroGaming",size: 24))
                                .foregroundColor(Color(uiColor: .systemGray6))
                                .frame(width: global_width*0.85)
                                .padding(.vertical)
                                .background(.white)
                                .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 5))
                                .clipShape(MessageBox())
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
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Add a new game")
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
