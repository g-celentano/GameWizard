//
//  MyGames.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 25/02/23.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = 0
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}




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
    @FetchRequest(sortDescriptors: []) var localGames : FetchedResults<MyGame>
    @Environment(\.managedObjectContext) var moc
    @State var isPresented = false
    @Environment(\.dismiss) private var dismiss
    @State var toolbarColor = Color.black
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color("BgColor")
                    .ignoresSafeArea(.all)
                
                localGames.isEmpty ? nil :
                    List{
                        ForEach(localGames, id: \.self){ game in
                            Text(game.gameName ?? "No name")
                                .font(Font.custom("RetroGaming", size: 16))
                        }
                        .onDelete(perform: delete)
                        
                    }
                    .background(GeometryReader{ proxy in
                        Color.clear.preference(key: ViewOffsetKey.self ,value: proxy.frame(in: .global).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self){
                        
                        if $0 < global_height*0.13{
                            toolbarColor = .white
                        } else {
                            toolbarColor = .black
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .clipped()
                    .toolbar(content: {
                            EditButton()
                                .font(Font.custom("RetroGaming", size: 16))
                                .foregroundColor(toolbarColor)
                    })
            }
            .frame(maxWidth: .infinity, maxHeight: global_height)
            
        }
       .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                }label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(Font.custom("RetroGaming", size: 16))
                            
                    }
                    .foregroundColor(toolbarColor)
                }
            }
           ToolbarItem(placement: .navigationBarTrailing) {
               Button{
                   isPresented.toggle()
               } label:{
               Image(systemName: "plus")
                   .foregroundColor(toolbarColor)
               }
           }
        }
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
        for offset in offsets {
            let game = localGames[offset]
            moc.delete(game)
        }
        try? moc.save()
    }
    
    
    struct MyGames_Preview : PreviewProvider {
        static var previews: some View {
            MyGames()
        }
    }
}
