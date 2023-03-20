//
//  Lists.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 02/03/23.
//

import SwiftUI



struct Lists: View {
    @Environment(\.dismiss) private var dismiss
    let pages = [NSLocalizedString("ALREADY SUGGESTED", comment: ""), NSLocalizedString("MY GAMES", comment: "")]
    @State var selectedPage = NSLocalizedString("MY GAMES", comment: "")
    @AppStorage("bg") var bg_color_storage : String = "BgColor"
    @State var bgValue = "BgColor"
    
    var body: some View {
        NavigationView{
            //TabView{
            VStack{
                HStack{
                    ZStack{
                        HStack{
                            Rectangle()
                                .frame(width: global_width*0.515)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: selectedPage == pages[1] ? .leading : .trailing)
                        HStack{
                            Spacer()
                            //HStack{
                                Text(pages[1])
                                    .font(Font.custom("RetroGaming", size: global_width*0.03))
                              //  Image("floppy")
                               //     .scaleEffect(0.15)
                               //     .frame(width: global_width*0.05)
                           // }
                            .frame(maxWidth: global_width*0.5, maxHeight: .infinity, alignment: .center)
                            .background(.white.opacity(0.7))
                            .onTapGesture {
                                withAnimation {
                                    selectedPage = pages[1]
                                }
                            }
                            
                            Text(pages[0])
                                .font(Font.custom("RetroGaming", size: global_width*0.03))
                                .frame(maxWidth: global_width*0.5, maxHeight: .infinity, alignment: .center)
                                .background(.white.opacity(0.7))
                                .onTapGesture {
                                    withAnimation {
                                        selectedPage = pages[0]
                                    }
                                }
                            Spacer()
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .foregroundColor(Color(uiColor: .systemGray6))
                .frame(maxWidth: global_width, maxHeight: global_height*0.05)
                .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 8))
                .clipShape(MessageBox())
                .padding(.vertical, global_height*0.01)
                
                
                TabView(selection: $selectedPage){
                    MyGames().tag(pages[1])
                    AlreadySuggestedView().tag(pages[0])
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .never))
               /* if selectedPage == pages[1] {
                    AlreadySuggestedView()
                } else {
                    MyGames()
                }
                    */
            }
            .background(Color(bgValue))
               
                
           //}
           //.frame(maxWidth: .infinity, maxHeight: .infinity)
           //.tabViewStyle(PageTabViewStyle())
           //.background(Color("BgColor"))
           //.ignoresSafeArea(.all)
        }
        .onAppear{
            bgValue = bg_color_storage
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                }label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text(NSLocalizedString("Back", comment: ""))
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
