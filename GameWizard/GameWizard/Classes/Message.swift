//
//  Messages.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 17/02/23.
//

import Foundation
import SwiftUI


struct Message: Identifiable {
    let id = UUID()
    let botResponse : Bool
    let text : String
    
}
/*
struct MessageBox : Shape{
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        

        //see how to draw shapes

        
        return path
    }
}
*/
