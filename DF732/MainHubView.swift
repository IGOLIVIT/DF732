//
//  MainHubView.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI

struct MainHubView: View {
    @EnvironmentObject var gameState: GameState
    @State private var showRoomOne = false
    @State private var showRoomTwo = false
    @State private var showStatistics = false
    @State private var animateGlow = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundPrimary.ignoresSafeArea()
                
                // Animated background
                GeometryReader { geometry in
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        index % 2 == 0 ? AppColors.mainAccent.opacity(0.15) : AppColors.secondaryAccent.opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 150, height: 150)
                            .blur(radius: 40)
                            .offset(
                                x: CGFloat(index % 3) * (geometry.size.width / 3) - 50,
                                y: CGFloat(index / 3) * (geometry.size.height / 4)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 4...7))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: animateGlow
                            )
                    }
                }
                .onAppear {
                    animateGlow = true
                }
                
                ScrollView {
                    VStack(spacing: AppLayout.spacing) {
                        Spacer()
                            .frame(height: 60)
                        
                        // Title Section
                        VStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppColors.mainAccent, AppColors.secondaryAccent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Light Points: \(gameState.lightPoints)")
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .foregroundColor(AppColors.mainAccent)
                        }
                        .padding(.bottom, 30)
                        
                        // Game Rooms
                        VStack(spacing: 20) {
                            NavigationLink(destination: GameRoomOneView().environmentObject(gameState)) {
                                GameRoomButton(
                                    title: "Play Room One",
                                    icon: "circle.fill",
                                    gradient: [AppColors.mainAccent, AppColors.mainAccent.opacity(0.7)]
                                )
                            }
                            
                            NavigationLink(destination: GameRoomTwoView().environmentObject(gameState)) {
                                GameRoomButton(
                                    title: "Play Room Two",
                                    icon: "circle.hexagongrid.fill",
                                    gradient: [AppColors.secondaryAccent, AppColors.secondaryAccent.opacity(0.7)]
                                )
                            }
                            
                            NavigationLink(destination: StatisticsView().environmentObject(gameState)) {
                                GameRoomButton(
                                    title: "Statistics & Progress",
                                    icon: "chart.bar.fill",
                                    gradient: [AppColors.mainAccent.opacity(0.6), AppColors.secondaryAccent.opacity(0.6)]
                                )
                            }
                        }
                        .padding(.horizontal, AppLayout.padding)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

struct GameRoomButton: View {
    let title: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(AppColors.backgroundPrimary)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                )
            
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(AppColors.backgroundPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.backgroundPrimary.opacity(0.7))
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppLayout.cornerRadius)
        .shadow(color: gradient[0].opacity(0.3), radius: 10, x: 0, y: 5)
    }
}


