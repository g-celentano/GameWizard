//
//  OnboardingView.swift
//  GameWizard
//
//  Created by Letterio Ugo Cangiano on 02/03/23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("currentView") var currentView = 1
    var body: some View {
        VStack{
            Text("This is a placeholder for the onboarding")
            Button{
                currentView = 2
            } label: {
                Text("Understood, take me to the chat.")
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
