//
//  Messages.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 17/02/23.
//

import Foundation
import CoreGraphics
import SwiftUI
import SVGKit

struct SizePreferenceKey : PreferenceKey {
    static var defaultValue: CGSize = .zero
     static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
extension View {
    func senderLayout(_ text : String, placeholder : String) -> some View {
      return self
          .font(Font.custom("RetroGaming", size: global_width*0.042))
          .foregroundColor(Color(uiColor: .systemGray6))
          .padding(.vertical)
          .padding(.horizontal, global_width*0.05)
          .background(
            Text(placeholder)
            .font(Font.custom("RetroGaming", size: 17))
            .frame(maxWidth: global_width*0.8, alignment: .leading)
            .foregroundColor(Color(uiColor: .systemGray))
            .padding(.vertical)
            .padding(.horizontal, global_width*0.05)
            .opacity(text.isEmpty ? 1.0 : 0.0)
          )
  }
    
    func messageLayout() -> some View{
        return self
            .padding()
            .padding(.horizontal)
            .font(Font.custom("RetroGaming", size: global_width*0.042))
            .foregroundColor(Color(uiColor: .systemGray6))
            .background(.white, in: MessageBoxV2BG())
            .lineLimit(nil)
            .overlay{
                MessageBoxV2Border().stroke(.black, lineWidth: 4.5)
            }
    }
    
}

class Message: Identifiable, Equatable, Hashable {
    
    //fields
    let id = UUID()
    private var botResponse : Bool
    private  var text : String
    private var games_in_message : [Game] = []
    
    
    //methods
    init(botR : Bool, t : String, games: [Game] = [] ) {
        self.botResponse = botR
        self.text = t
        self.games_in_message = games
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.botResponse == rhs.botResponse && lhs.text == rhs.text && lhs.id == rhs.id
        
    }
    func setBotResponse(botRes : Bool) {
        self.botResponse = botRes
    }
    
    
    func setText(text : String) {
        self.text = text
    }
    
    func setGames(games : [Game]){
        for game in games {
            self.games_in_message.append(game)
        }
    }
    
    func addGame(game: Game) {
        self.games_in_message.append(game)
    }
    
    func getGames() -> [Game]{
        return self.games_in_message
    }
    func isBotResponse()->Bool {
        return self.botResponse
    }
    func getText() -> String {
        return self.text
    }
    
    
}




struct MessageBox : Shape {
    
    
    func path(in rect: CGRect)-> Path{
        Path{ path in
            let w = rect.width
            let h = rect.height
            let x0 = rect.origin.x
            let y0 = rect.origin.y
           
            path.move(to: CGPoint(x: x0 + global_width*0.05, y: y0))
            path.addLine(to: CGPoint(x: w - global_width*0.05, y: y0))
            path.addLine(to: CGPoint(x: w - global_width*0.05, y: y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.03, y:y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.03, y:y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.015, y:y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.015, y:h - global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.03, y:h - global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.03, y:h - global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.05, y:h - global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.05, y:h))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y:h))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y:h - global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.03, y: h - global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.03, y: h - global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.015, y: h - global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.015, y: y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.03, y: y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.03, y: y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y: y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y: y0 ))
            path.closeSubpath()
        }
    }
    
}

struct MessageBoxV2Border: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            let w = rect.size.width
            let h = rect.size.height
            
            // top horizontal line
            path.move(to: CGPoint(x: global_width * 0.05, y: 0))
            path.addLine(to: CGPoint(x: w - global_width * 0.05, y: 0))
            path.closeSubpath()
            
            //top right corner
            path.move(to: CGPoint(x: w - global_width * 0.05, y: global_height * 0.004))
            path.addLine(to: CGPoint(x: w - global_width * 0.038 , y: global_height * 0.004))
            path.closeSubpath()
            
            //right vertical line
            path.move(to: CGPoint(x: w - global_width * 0.033, y: global_height * 0.005))
            path.addLine(to: CGPoint(x: w - global_width * 0.033, y: h - global_height * 0.005))
            path.closeSubpath()
            
            //bottom right corner
            path.move(to: CGPoint(x: w - global_width * 0.05, y: h - global_height * 0.004))
            path.addLine(to: CGPoint(x: w - global_width * 0.038 , y: h - global_height * 0.004))
            path.closeSubpath()
            
            //bottom line
            path.move(to: CGPoint(x: global_width * 0.05, y: h))
            path.addLine(to: CGPoint(x: w - global_width * 0.05, y: h))
            path.closeSubpath()
            
            //bottom left corner
            path.move(to: CGPoint(x: global_width * 0.05, y: h - global_height * 0.004))
            path.addLine(to: CGPoint(x:  global_width * 0.038 , y: h - global_height * 0.004))
            path.closeSubpath()
            
            //left vertical line
            path.move(to: CGPoint(x: global_width * 0.033, y: global_height * 0.005))
            path.addLine(to: CGPoint(x: global_width * 0.033, y: h - global_height * 0.005))
            path.closeSubpath()
            
            //top left corner
            path.move(to: CGPoint(x: global_width * 0.05, y: global_height * 0.004))
            path.addLine(to: CGPoint(x: global_width * 0.038, y: global_height * 0.004))
            path.closeSubpath()
            
            
            
        }
    }
}

struct MessageBoxV2BG: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            let w = rect.size.width
            let h = rect.size.height
            
            // Background Piece
            path.addRect(CGRect(origin: CGPoint(x: global_width * 0.038, y: global_height * 0.002), size: CGSize(width: w - global_width * 0.05 - global_width * 0.027, height: h - global_height * 0.004)))
            
        }
    }
}



struct MessageBG_Previews : PreviewProvider {
    
    static var previews: some View{
      VStack {
          MessageBox()
              .stroke(.black, lineWidth: 4)
              .frame(width: global_width*0.9, height: global_height*0.1)
          
         MessageBoxV2Border()
              .stroke(.black, lineWidth: 4.5)
              .background(.white,in: MessageBoxV2BG())
              .frame(width: global_width*0.9, height: global_height*0.1)
          
         Text("Hello World aosdnoaisnod a sdkdnasnd snjadai osidnaoisndoisndoinasoindosaibdoiusabodbasobdouasbodbasojbdouaboisabodubsabdoausbdoubaoudbaoudboasubdaoubdouasbdouasbdouasbdouasbdousabd")
              .messageLayout()
          
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color("BgColor"))
      
      
    }
}
