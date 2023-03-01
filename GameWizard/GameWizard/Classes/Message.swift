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
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

class Message: Identifiable, Equatable, Hashable {
    
    //fields
    let id = UUID()
    private var botResponse : Bool
    private  var text : String
    
    
    //methods
    init(botR : Bool, t : String) {
        self.botResponse = botR
        self.text = t
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
