//
//  GameRoomOneView.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI
import Combine

struct FallingSphere: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var color: Color
    var scale: CGFloat = 1.0
}

struct Peg: Identifiable {
    let id = UUID()
    let position: CGPoint
    let radius: CGFloat = 15
}

struct GameRoomOneView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    @State private var spheres: [FallingSphere] = []
    @State private var pegs: [Peg] = []
    @State private var targetZoneHighlight = false
    @State private var showPointAnimation = false
    @State private var pointAnimationPosition: CGPoint = .zero
    
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    let gravity: CGFloat = 0.5
    let bounceDamping: CGFloat = 0.7
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.mainAccent)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .foregroundColor(AppColors.secondaryAccent)
                            Text("\(gameState.lightPoints)")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.mainAccent.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, AppLayout.padding)
                    .padding(.top, 10)
                    
                    // Game Area
                    ZStack {
                        // Pegs
                        ForEach(pegs) { peg in
                            Circle()
                                .fill(AppColors.mainAccent.opacity(0.6))
                                .frame(width: peg.radius * 2, height: peg.radius * 2)
                                .position(peg.position)
                                .shadow(color: AppColors.mainAccent.opacity(0.4), radius: 8)
                        }
                        
                        // Target Zone
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppColors.secondaryAccent.opacity(targetZoneHighlight ? 0.4 : 0.2),
                                        AppColors.secondaryAccent.opacity(targetZoneHighlight ? 0.2 : 0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 180, height: 60)
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 140)
                            .overlay(
                                Text("TARGET")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColors.secondaryAccent)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height - 140)
                            )
                        
                        // Falling Spheres
                        ForEach(spheres) { sphere in
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [sphere.color.opacity(0.9), sphere.color.opacity(0.5)],
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 20
                                    )
                                )
                                .frame(width: 30, height: 30)
                                .position(sphere.position)
                                .scaleEffect(sphere.scale)
                                .shadow(color: sphere.color.opacity(0.6), radius: 10)
                        }
                        
                        // Point Animation
                        if showPointAnimation {
                            Text("+1")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.secondaryAccent)
                                .position(pointAnimationPosition)
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        addSphere(at: CGPoint(x: location.x, y: 50), in: geometry.size)
                    }
                    
                    // Instructions
                    Text("Tap to drop a sphere")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.bottom, 20)
                }
            }
            .onAppear {
                setupPegs(in: geometry.size)
            }
            .onReceive(timer) { _ in
                updatePhysics(in: geometry.size)
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
    
    func setupPegs(in size: CGSize) {
        pegs.removeAll()
        let rows = 6
        let columns = 5
        
        for row in 0..<rows {
            let y = 150 + CGFloat(row) * 80
            let offset = row % 2 == 0 ? 0 : 40
            
            for col in 0..<columns {
                let x = 50 + CGFloat(col) * 70 + CGFloat(offset)
                if x > 20 && x < size.width - 20 {
                    pegs.append(Peg(position: CGPoint(x: x, y: y)))
                }
            }
        }
    }
    
    func addSphere(at position: CGPoint, in size: CGSize) {
        let colors: [Color] = [AppColors.mainAccent, AppColors.secondaryAccent]
        let randomColor = colors.randomElement() ?? AppColors.mainAccent
        
        let sphere = FallingSphere(
            position: position,
            velocity: CGPoint(x: CGFloat.random(in: -2...2), y: 0),
            color: randomColor
        )
        spheres.append(sphere)
    }
    
    func updatePhysics(in size: CGSize) {
        for index in spheres.indices {
            // Apply gravity
            spheres[index].velocity.y += gravity
            
            // Update position
            spheres[index].position.x += spheres[index].velocity.x
            spheres[index].position.y += spheres[index].velocity.y
            
            // Bounce off walls
            if spheres[index].position.x < 15 {
                spheres[index].position.x = 15
                spheres[index].velocity.x *= -bounceDamping
            }
            if spheres[index].position.x > size.width - 15 {
                spheres[index].position.x = size.width - 15
                spheres[index].velocity.x *= -bounceDamping
            }
            
            // Check collision with pegs
            for peg in pegs {
                let dx = spheres[index].position.x - peg.position.x
                let dy = spheres[index].position.y - peg.position.y
                let distance = sqrt(dx * dx + dy * dy)
                
                if distance < 15 + peg.radius {
                    let angle = atan2(dy, dx)
                    let force: CGFloat = 3
                    spheres[index].velocity.x = cos(angle) * force
                    spheres[index].velocity.y = sin(angle) * force * bounceDamping
                    
                    // Push sphere away from peg
                    let overlap = (15 + peg.radius) - distance
                    spheres[index].position.x += cos(angle) * overlap
                    spheres[index].position.y += sin(angle) * overlap
                }
            }
            
            // Check if in target zone
            let targetX = size.width / 2
            let targetY = size.height - 140
            
            if abs(spheres[index].position.x - targetX) < 90 &&
               abs(spheres[index].position.y - targetY) < 30 &&
               !spheres[index].scale.isLess(than: 1.0) {
                
                spheres[index].scale = 0.5
                gameState.addLightPoint()
                targetZoneHighlight = true
                
                pointAnimationPosition = spheres[index].position
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showPointAnimation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showPointAnimation = false
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    targetZoneHighlight = false
                }
            }
            
            // Remove spheres that fall off screen
            if spheres[index].position.y > size.height + 50 {
                spheres.remove(at: index)
                return
            }
        }
    }
}

