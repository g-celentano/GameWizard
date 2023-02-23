//
//  ContentView.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/02/23.
//

import SwiftUI


let global_height = UIScreen.main.bounds.height
let global_width  = UIScreen.main.bounds.width
let games : [Game] = load("games")
let recommender : Recommender = Recommender()

struct ContentView: View {
    
    @State var userBoxes : [CGSize] = []
    @State var botBoxes : [CGSize] = []
    
    @State var textFieldValue : String = ""
    @State var botResponse : String = ""
    @State var lastMexWidt : Double = 0.0
    @State var messages : [Message] = [
        //Message(botR: false, t: "Ciao "),
        //Message(botR: true, t: "Ciao a te")
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("BgColor"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack{
                /*Button {
                 callAPI()
                 } label: {
                 Text("Click here to import the Steam Library")
                 .font(.system(size: 20))
                 }*/
                ScrollView{
                    
                    ForEach(messages){ message in
                        HStack {
                            HStack{
                                
                                //Text(messages.last == message && message.isBotResponse() && lastMexWidt < global_width*0.4 ? "" : message.getText() )
                                Text(message.getText())
                                    .lineLimit(nil)
                                    .font(.title3)
                                    .padding()
                                    //.frame(minWidth: messages.last == message && message.isBotResponse() ? lastMexWidt :  global_width*0.4 ,minHeight: global_height * 0.05, maxHeight: .infinity,  alignment: .leading)
                                    .frame(minWidth:  global_width*0.4 ,minHeight: global_height * 0.05, maxHeight: .infinity,  alignment: .leading)
                                    /*.clipShape(MessageBox(x0_y0: CGPoint(x: 0.0 ,y: 0.0),
                                                          x1_y0: CGPoint(x: message.isBotResponse() ? botBoxes[messages.firstIndex(of: message) ?? 0].width : userBoxes[messages.firstIndex(of: message) ?? 0].width,
                                                                         y: 0.0 ),
                                                          x1_y1: CGPoint(x: message.isBotResponse() ? botBoxes[messages.firstIndex(of: message) ?? 0].width : userBoxes[messages.firstIndex(of: message) ?? 0].width,
                                                                         y: global_height*0.05),
                                                          x0_y1: CGPoint(x: 0.0, y: message.isBotResponse() ? botBoxes[messages.firstIndex(of: message) ?? 0].height : userBoxes[messages.firstIndex(of: message) ?? 0].height))) //check if dims are nil
                                    .background(.white)
                                    .readSize { newSize in
                                        //message.setSize(w: nil , h: nil ,s: newSize)
                                    }*/
                            }
                            .frame(minWidth: global_width*0.04, maxWidth: global_width*0.7,minHeight: global_height*0.05, maxHeight: .infinity,alignment: message.isBotResponse() ? .leading : .trailing) // max message expansion
                            
                        }
                        .frame(maxWidth: global_width*0.9, alignment: message.isBotResponse() ? .leading : .trailing )
                    }
                    
                    
                }
                .frame(maxWidth: global_width, maxHeight: .infinity, alignment: .bottom)
                .padding()
                
                
                
    
                HStack{
                    TextField("Type Here...", text: $textFieldValue)
                        .submitLabel(.send)
                        .padding(.leading)
                        .frame(maxWidth: global_width*0.9, maxHeight: global_height*0.05)
                        .onSubmit {
                            lastMexWidt = 0.0
                            messages.append(Message(botR: false, t: textFieldValue))
                            //userBoxes.append(CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>))
                            
                            
                            lastMexWidt = global_width * 0.05
                            
                            let response = recommender.get_sentiment(text: textFieldValue)
                            messages.append(Message(botR: true, t: response))
                            
                            
                            
                            /*DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { // used to replicate response time
                                
                                withAnimation {
                                    lastMexWidt = global_width * 0.4
                                }
                                
                            })*/
                            textFieldValue = ""
                            
                        }
                    Button {
                        print("ciao")
                    } label: {
                        ZStack{
                            Image(systemName: textFieldValue.isEmpty ? "mic.fill" : "paperplane.fill" )
                                .foregroundColor(.white)
                        }
                        .frame(width: global_width*0.1, height: global_width*0.1, alignment: .center)
                        .background(.blue)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                    
                    
                }
                .frame(maxWidth: global_width * 0.95, maxHeight: global_height * 0.06, alignment: .center)
                .background(.white)
                .cornerRadius(18)
                .padding(.vertical)
            
                
            }
            .frame(maxWidth: .infinity, maxHeight: global_height, alignment: .bottom)
            
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
