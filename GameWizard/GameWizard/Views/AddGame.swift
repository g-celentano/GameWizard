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
            .foregroundColor : UIColor.black,
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
                        .foregroundColor(.black)
                        .frame(maxWidth: global_width*0.9)
                        .background(
                            Text("Game Name")
                                .font(Font.custom("RetroGaming", size: 17))
                                .frame(maxWidth: global_width*0.9, alignment: .leading)
                                .foregroundColor(.gray)
                                .padding(.horizontal, global_width*0.05)
                                .opacity(gameName.isEmpty ? 1.0 : 0.0)
                        )
                        .padding(.vertical)
                        .background(.white)
                        .clipped()
                        .overlay(MessageBox().stroke(.black, lineWidth: 8))
                        .clipShape(MessageBox())
                    
                        
                        HStack{
                            Text("Game Genres")
                                .font(Font.custom("RetroGaming", size: 24))
                                .foregroundColor(.black)
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
                                    .foregroundColor(.black)
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
                                    .foregroundColor(.black)
                                    .frame(maxWidth: global_width*0.9)
                                    .background(
                                        Text("Game Genre")
                                            .font(Font.custom("RetroGaming", size: 17))
                                            .frame(maxWidth: global_width*0.8, maxHeight: global_height*0.05, alignment: .leading)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, global_width*0.05)
                                            .opacity(genres[index].isEmpty ? 1.0 : 0.0)
                                    )
                                    .padding(.vertical)
                                    .background(.white)
                                    .clipped()
                                    .overlay(MessageBox().stroke(.black, lineWidth: 8))
                                    .clipShape(MessageBox())
                                
                            }
                        }
                        .frame(maxWidth: global_width*0.9, maxHeight: .infinity)
                        
                    Button{
                        if !(gameName.isEmpty && genres.isEmpty){
                            let newGame = MyGame(context: moc)
                            newGame.id = UUID()
                            newGame.gameName = gameName
                            newGame.genres = genres
                            try? moc.save()
                            dismiss()
                        }
                    }label: {
                        Text("Add")
                            .font(Font.custom("RetroGaming",size: 24))
                            .foregroundColor(.black)
                            .frame(width: global_width*0.85)
                            .padding(.vertical)
                            .background(.white)
                            .overlay(MessageBox().stroke(.black, lineWidth: 5))
                            .clipShape(MessageBox())
                    }
                    
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                    
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
                            .foregroundColor(.black)
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
