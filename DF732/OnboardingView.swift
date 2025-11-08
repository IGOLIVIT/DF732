//
//  OnboardingView.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    let pages = [
        OnboardingPage(
            title: "Welcome to a world of falling light.",
            icon: "sparkles"
        ),
        OnboardingPage(
            title: "Each room holds a new motion puzzle.",
            icon: "square.stack.3d.up.fill"
        ),
        OnboardingPage(
            title: "Collect light points. Unlock new visual themes.",
            icon: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            // Animated background elements
            GeometryReader { geometry in
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.mainAccent.opacity(0.1),
                                    AppColors.secondaryAccent.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .blur(radius: 30)
                        .offset(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...5))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                            value: currentPage
                        )
                }
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(height: 400)
                
                Spacer()
                
                if currentPage == pages.count - 1 {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isOnboardingComplete = true
                        }
                    }) {
                        Text("Begin")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(AppColors.backgroundPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.mainAccent)
                            .cornerRadius(AppLayout.buttonCornerRadius)
                    }
                    .padding(.horizontal, AppLayout.padding)
                    .padding(.bottom, AppLayout.padding)
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(AppColors.backgroundPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.mainAccent)
                            .cornerRadius(AppLayout.buttonCornerRadius)
                    }
                    .padding(.horizontal, AppLayout.padding)
                    .padding(.bottom, AppLayout.padding)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingPage {
    let title: String
    let icon: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.mainAccent, AppColors.secondaryAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .opacity(isAnimated ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isAnimated)
            
            Text(page.title)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppLayout.padding)
                .opacity(isAnimated ? 1.0 : 0.0)
                .offset(y: isAnimated ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isAnimated)
        }
        .onAppear {
            isAnimated = true
        }
    }
}


