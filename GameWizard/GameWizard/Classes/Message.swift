//
//  Messages.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 17/02/23.
//

import Foundation
import CoreGraphics
import SwiftUI

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
            .background(Color(uiColor: .white))
            .lineLimit(nil)
            .clipShape(MessageBox())
            .overlay(MessageBox().stroke(Color(uiColor: .systemGray6), lineWidth: 2))
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
            path.addLine(to: CGPoint(x: w - global_width*0.025, y:y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.025, y:y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.0125, y:y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.0125, y:h - global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.025, y:h - global_height*0.015))
            path.addLine(to: CGPoint(x: w - global_width*0.025, y:h - global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.05, y:h - global_height*0.005))
            path.addLine(to: CGPoint(x: w - global_width*0.05, y:h))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y:h))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y:h - global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.025, y: h - global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.025, y: h - global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.0125, y: h - global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.0125, y: y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.025, y: y0 + global_height*0.015))
            path.addLine(to: CGPoint(x: x0 + global_width*0.025, y: y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y: y0 + global_height*0.005))
            path.addLine(to: CGPoint(x: x0 + global_width*0.05, y: y0 ))
            path.closeSubpath()
        }
    }
    
}

struct MessageBG_Previews : PreviewProvider {
    static var previews: some View{
      VStack {
          MessageBox().stroke(.black, lineWidth: 6)
      }
      .frame(width: global_width*0.9, height: global_height*0.1)
      
    }
}
