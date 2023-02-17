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
