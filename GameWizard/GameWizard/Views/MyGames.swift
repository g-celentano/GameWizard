//
//  MyGames.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 25/02/23.
//

import SwiftUI
var myGames : [Game] = games

struct MyGames : View {
    
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
    
    @State var isPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color("BgColor")
                    .ignoresSafeArea(.all)
                
                myGames.isEmpty ? nil :
                List{
                    ForEach(myGames){ game in
                        Text(game.name)
                            .font(Font.custom("RetroGaming", size: 16))
                    }
                    .onDelete(perform: delete)
                    
                }
                .scrollContentBackground(.hidden)
                .clipped()
                .toolbar(content: {
                        EditButton()
                            .font(Font.custom("RetroGaming", size: 16))
                            .foregroundColor(.white)
                    Button{
                        isPresented.toggle()
                    } label:{
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    }
                      
                    
                })
                
                   
            }
            .frame(maxWidth: .infinity, maxHeight: global_height)
        }
       .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                }label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(Font.custom("RetroGaming", size: 16))
                            
                    }
                    .foregroundColor(.white)
                }
            }
        })
        .navigationTitle("My Games")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isPresented, content: {
            NavigationStack{
                AddGame()
            }
        })
    }
    
    func delete(at offsets : IndexSet){
        myGames.remove(atOffsets: offsets)
    }
    
    
    struct MyGames_Preview : PreviewProvider {
        static var previews: some View {
            MyGames()
        }
    }
}
