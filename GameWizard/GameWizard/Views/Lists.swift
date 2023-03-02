//
//  Lists.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 02/03/23.
//

import SwiftUI



struct Lists: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView{
            TabView{
                MyGames()
                
                AlreadySuggestedView()
                
            }
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabViewStyle(PageTabViewStyle())
            .background(Color("BgColor"))
            .ignoresSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                }label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(Font.custom("RetroGaming", size: 16))
                            
                    }
                    //.foregroundColor(toolbarColor)
                    .foregroundColor(Color(uiColor: .systemGray6))
                }
            }
        }
    }
}

struct Lists_Previews: PreviewProvider {
    static var previews: some View {
        Lists()
    }
}
