//
//  Theme.swift
//  CarCantroller
//
//  Created by Habishek on 31/10/25.
//



import SwiftUI

// MARK: - Car Theme Colors
struct CarTheme {
    static let darkBlue = Color(red: 12/255, green: 18/255, blue: 28/255)
    static let neonBlue = Color(red: 0.2, green: 0.8, blue: 1.0)
    static let accentRed = Color(red: 1.0, green: 0.2, blue: 0.3)
    static let accentGreen = Color(red: 0.3, green: 1.0, blue: 0.6)
    static let panelGray = Color(red: 0.15, green: 0.15, blue: 0.17)
    static let backgroundGlow = Color(red: 0.1, green: 0.1, blue: 0.15)
}

// MARK: - Custom Glow Modifier
extension View {
    /// Applies a futuristic, neon glow effect.
    func glow(color: Color, radius: CGFloat) -> some View {
        self.shadow(color: color, radius: radius / 2)
            .shadow(color: color.opacity(0.5), radius: radius)
    }
}
