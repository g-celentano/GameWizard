//
//  AnimatedMenuIcon.swift
//  GameWizard
//
//  Created by Gaetano Celentano on 15/04/23.
//

import SwiftUI

struct AnimatedMenuIcon: View {
    
    @Binding var openMenu : Bool
    @State var xOffset: Double = global_width * 0.025
    @State var closeHeight: Double = 0.0
    
    
    var body: some View {
        VStack{
            ZStack{
                Image("dot")
                    .scaleEffect(0.165)
                    .frame(width: global_width * 0.012)
                    .offset(x: -xOffset, y: 0.0)
                    
                Image("dot")
                    .scaleEffect(0.165)
                    .frame(width: global_width * 0.012)
                
                Image("dot")
                    .scaleEffect(0.165)
                    .frame(width: global_width * 0.012)
                    .offset(x: xOffset, y: 0.0)
                
                Rectangle()
                    .frame(width: global_width * 0.015, height: closeHeight)
                    .rotationEffect(.degrees(45))
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: global_width * 0.015, height: closeHeight)
                    .rotationEffect(.degrees(-45))
                    .foregroundColor(.black)
                
            }
            .frame(width: global_width*0.12, height: global_width*0.1)
                
        }
        .frame(width: global_width*0.12, height: global_width*0.1)
        .onChange(of: openMenu) { _ in
            if openMenu {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                    withAnimation(.linear(duration:0.15)){
                        xOffset = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                        withAnimation(.linear(duration:0.1)){
                            closeHeight = global_width * 0.07
                        }
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                    withAnimation(.linear(duration:0.15)){
                       xOffset = global_width * 0.025
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                        withAnimation(.linear(duration:0.1)){
                            closeHeight = 0.0
                        }
                    }
                }
            }
        }
    }
}

struct AnimatedMenuIcon_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedMenuIcon(openMenu: .constant(false))
    }
}
