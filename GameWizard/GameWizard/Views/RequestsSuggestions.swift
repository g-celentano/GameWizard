//
//  RequestsSuggestions.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/04/23.
//

import SwiftUI

struct RequestsSuggestions: View {
    
    @State var samples : [String] = [
        "Tell me a game about (keyword)",
        "Suggest me a (keyword) game",
        "Tell me some games about (keyword)",
        "Tell me some games like (keyword)",
    ]
    @Binding var textfield : String
    @Binding var openMenu : Bool
    
    var body: some View {
        VStack{
            Text("Request Suggestions")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Font.custom("RetroGaming", size: global_width*0.042))
            ScrollView{
                ForEach(samples, id: \.self){ sample in
                    Text("✰ \"\(sample)\"")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.custom("RetroGaming", size: global_width*0.035))
                        .onTapGesture{
                            textfield = sample.replacingOccurrences(of: "(keyword)", with: "")
                            withAnimation{
                                openMenu = false
                            }
                        }
                }
            }
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct RequestsSuggestions_Previews: PreviewProvider {
    static var previews: some View {
        RequestsSuggestions(textfield: .constant("Hello"), openMenu: .constant(false))
    }
}
