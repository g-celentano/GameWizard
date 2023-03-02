//
//  MyGames.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 25/02/23.
//

import SwiftUI


struct AlreadySuggestedView : View {
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: "RetroGaming", size: 32)!,
            .foregroundColor : UIColor.systemGray6,
        ]
        
        
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "RetroGaming", size: 20)!,
            .foregroundColor : UIColor.white
        ]
    }
    @FetchRequest(sortDescriptors: []) var alreadySuggested : FetchedResults<AlreadySuggested>
    @Environment(\.managedObjectContext) var moc
    @State var isPresented = false
    @Environment(\.dismiss) private var dismiss
    @State var toolbarColor = Color(uiColor: .systemGray6)
    @State var isEditing = false
    
    var body: some View{
        //NavigationStack{
            ZStack{
                Color("BgColor")
                    .ignoresSafeArea(.all)
                VStack{
                    HStack{
                        Text("Already Suggested")
                            .font(Font.custom("RetroGaming", size: 30))
                        
                    }
                    .foregroundColor(Color(uiColor: .systemGray6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, global_width*0.05)
                    
                
                    alreadySuggested.isEmpty ? nil :
                    
                        List{
                            ForEach(alreadySuggested, id: \.self){ game in
                                Text(game.gameName ?? "No name")
                                    .font(Font.custom("RetroGaming", size: 16))
                                    .listRowSeparatorTint(Color("BgColor"))
                            }
                            .onDelete(perform: delete)
                            
                        }
                        .listRowSeparator(.visible)
                        .background(GeometryReader{ proxy in
                            Color.clear.preference(key: ViewOffsetKey.self ,value: proxy.frame(in: .global).origin.y)
                        })
                        /*.onPreferenceChange(ViewOffsetKey.self){
                            
                            if $0 < global_height*0.13{
                                toolbarColor = Color(uiColor: .white)
                            } else {
                                toolbarColor = Color(uiColor: .systemGray6)
                            }
                        }*/
                        .scrollContentBackground(.hidden)
                        .clipped()
                        .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
                        /*
                        .toolbar(content: {
                                EditButton()
                                    .font(Font.custom("RetroGaming", size: 16))
                                    .foregroundColor(toolbarColor)
                        })*/
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
       // }
       /*.toolbar {
           ToolbarItem(placement: .navigationBarTrailing) {
               Button{
                   isPresented.toggle()
               } label:{
               Image(systemName: "plus")
                   .foregroundColor(toolbarColor)
               }
           }
        }*/
        //.navigationTitle("My Games")
        //.navigationBarTitleDisplayMode(.large)
        //.navigationBarBackButtonHidden(true)
    }
    
    func delete(at offsets : IndexSet){
        for offset in offsets {
            let game = alreadySuggested[offset]
            moc.delete(game)
        }
        try? moc.save()
    }
    
    
    struct AlreadySuggested_Preview : PreviewProvider {
        static var previews: some View {
            AlreadySuggestedView()
        }
    }
}
