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

class Message: Identifiable, Equatable {
    
    //fields
    let id = UUID()
    private var botResponse : Bool
    private  var text : String
    
    
    //methods
    init(botR : Bool, t : String) {
        self.botResponse = botR
        self.text = t
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        if  lhs.botResponse == rhs.botResponse &&
            lhs.text == rhs.text &&
            lhs.id == rhs.id {
            return true
        } else {
            return false
        }
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
    let x0_y0 : CGPoint
    let x1_y0 : CGPoint
    let x1_y1 : CGPoint
    let x0_y1 : CGPoint
    func path(in rect: CGRect)-> Path{
        Path{ path in
            path.move(to: x0_y0)
            path.addLine(to: x1_y0)
            path.addLine(to: x1_y1)
            path.addLine(to: x0_y1)
        }
    }
}

struct MessageBG_Previews : PreviewProvider {
    static var previews: some View{
      VStack {
          MessageBox(x0_y0: CGPoint(x: global_width*0.99, y: 0),
                     x1_y0: CGPoint(x: global_width*0.01, y: 0),
                     x1_y1: CGPoint(x: global_width*0.01, y: global_height*0.2),
                     x0_y1: CGPoint(x: global_width*0.99, y: global_height*0.2))
       }
      
    }
}
