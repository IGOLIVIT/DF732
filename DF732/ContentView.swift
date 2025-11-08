//
//  ContentView.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        Group {
            if gameState.hasCompletedOnboarding {
                MainHubView()
                    .environmentObject(gameState)
            } else {
                OnboardingView(isOnboardingComplete: $gameState.hasCompletedOnboarding)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
