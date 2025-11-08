//
//  DesignSystem.swift
//  DF732
//
//  Created by IGOR on 06/11/2025.
//

import SwiftUI

struct AppColors {
    static let backgroundPrimary = Color(hex: "#0D1B2A")
    static let mainAccent = Color(hex: "#7BFF45")
    static let secondaryAccent = Color(hex: "#FFD93D")
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
}

struct AppLayout {
    static let cornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 16
    static let padding: CGFloat = 24
    static let spacing: CGFloat = 16
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


