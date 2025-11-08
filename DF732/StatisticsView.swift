//
//  StatisticsView.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    @State private var showResetConfirmation = false
    @State private var animateStats = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            // Animated background
            GeometryReader { geometry in
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    index % 2 == 0 ? AppColors.mainAccent.opacity(0.1) : AppColors.secondaryAccent.opacity(0.08),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 50)
                        .offset(
                            x: CGFloat(index % 3) * (geometry.size.width / 3),
                            y: CGFloat(index / 3) * (geometry.size.height / 2)
                        )
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 5...8))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.4),
                            value: animateStats
                        )
                }
            }
            .onAppear {
                animateStats = true
            }
            
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
                    
                    Text("Statistics")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    // Invisible spacer for centering
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, AppLayout.padding)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        Spacer()
                            .frame(height: 40)
                        
                        // Main Stats Card
                        VStack(spacing: 24) {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppColors.mainAccent, AppColors.secondaryAccent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .scaleEffect(animateStats ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateStats)
                            
                            VStack(spacing: 8) {
                                Text("Total Light Points")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Text("\(gameState.lightPoints)")
                                    .font(.system(size: 60, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [AppColors.mainAccent, AppColors.secondaryAccent],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                        }
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadius)
                                .fill(AppColors.mainAccent.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppLayout.cornerRadius)
                                        .stroke(AppColors.mainAccent.opacity(0.2), lineWidth: 2)
                                )
                        )
                        .padding(.horizontal, AppLayout.padding)
                        
                        // Progress Message
                        VStack(spacing: 12) {
                            if gameState.lightPoints == 0 {
                                Text("Start your journey")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Play mini-games to collect light points")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                            } else if gameState.lightPoints < 10 {
                                Text("Great start!")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Keep playing to discover more")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                            } else if gameState.lightPoints < 50 {
                                Text("Making progress!")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Your light collection is growing")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("Impressive!")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("You've mastered the falling light")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, AppLayout.padding)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        // Reset Button
                        Button(action: {
                            showResetConfirmation = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Reset Progress")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(AppColors.backgroundPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.textSecondary.opacity(0.3), AppColors.textSecondary.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(AppLayout.buttonCornerRadius)
                        }
                        .padding(.horizontal, AppLayout.padding)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
        .alert("Reset Progress", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    gameState.resetProgress()
                }
            }
        } message: {
            Text("Are you sure you want to reset all your light points? This action cannot be undone.")
        }
    }
}


