//
//  GameState.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI
import Combine

class GameState: ObservableObject {
    @AppStorage("lightPoints") var lightPoints: Int = 0
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    func addLightPoint() {
        lightPoints += 1
    }
    
    func resetProgress() {
        lightPoints = 0
    }
}

