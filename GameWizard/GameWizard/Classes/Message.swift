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
    
    func path(in rect: CGRect)-> Path{
        Path{ path in
           let w = rect.width
           let h = rect.height
           let x0 = rect.origin.x
           let y0 = rect.origin.y
           
           path.move(to: CGPoint(x: x0 + w*0.05, y: y0))
           path.addLine(to: CGPoint(x: w - w*0.05, y: y0))
           path.addLine(to: CGPoint(x: w - w*0.05, y: y0+h*0.08))
           path.addLine(to: CGPoint(x: w, y: y0+h*0.08))
           path.addLine(to: CGPoint(x: w, y: h-h*0.08))
           path.addLine(to: CGPoint(x: w - w*0.05, y: h-h*0.08))
           path.addLine(to: CGPoint(x: w - w*0.05, y: h))
           path.addLine(to: CGPoint(x: x0 + w*0.05, y: h))
           path.addLine(to: CGPoint(x: x0 + w*0.05, y: h-h*0.08))
           path.addLine(to: CGPoint(x: x0, y: h-h*0.08))
           path.addLine(to: CGPoint(x: x0, y: y0+h*0.08))
           path.addLine(to: CGPoint(x: x0 + w*0.05, y: y0+h*0.08))
           path.addLine(to: CGPoint(x: x0 + w*0.05, y: y0))
            
        }
    }
    
}

struct MessageBG_Previews : PreviewProvider {
    static var previews: some View{
      VStack {
          MessageBox()
      }
      .frame(minWidth: global_width*0.3, maxWidth: global_width*0.7, minHeight: global_height*0.2, maxHeight: global_height*0.2)
      
    }
}
