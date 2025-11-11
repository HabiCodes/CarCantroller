//
//  ControlViews.swift
//  CarCantroller
//
//  Created by Habishek on 31/10/25.
//


import SwiftUI

// MARK: - Control Panel Layout
struct ControlPanelView: View {
    @ObservedObject var udp: UDPClient // Use ObservedObject here to ensure data updates

    var body: some View {
        VStack(spacing: 25) {
            // UP
            ControlButton(icon: "arrow.up", color: CarTheme.neonBlue, action: { udp.send("front") }, isConnected: udp.connectionActive)

            HStack(spacing: 25) {
                // LEFT
                ControlButton(icon: "arrow.left", color: CarTheme.neonBlue, action: { udp.send("left") }, isConnected: udp.connectionActive)
                
                // STOP
                StopButton(action: { udp.send("stop") }, isConnected: udp.connectionActive)
                
                // RIGHT
                ControlButton(icon: "arrow.right", color: CarTheme.neonBlue, action: { udp.send("right") }, isConnected: udp.connectionActive)
            }

            // DOWN
            ControlButton(icon: "arrow.down", color: CarTheme.neonBlue, action: { udp.send("back") }, isConnected: udp.connectionActive)
        }
        .padding(.top, 30)
    }
}

// MARK: - Control Button
struct ControlButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    let isConnected: Bool // Added dependency to disable when offline
    
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard isConnected else { return } // Disabled when offline
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { isPressed = false }
        }) {
            Image(systemName: icon)
                .font(.largeTitle.bold())
                .foregroundColor(color)
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(CarTheme.panelGray)
                        // Neumorphic/Futuristic Shadowing
                        .shadow(color: isPressed ? .black : .black.opacity(0.8), radius: 10, x: isPressed ? 0 : 5, y: isPressed ? 0 : 5)
                        .shadow(color: isPressed ? color : .white.opacity(0.1), radius: 5, x: isPressed ? 0 : -3, y: isPressed ? 0 : -3)
                )
                // GLOW Effect on Press
                .glow(color: isPressed ? color : .clear, radius: 12)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .opacity(isConnected ? 1.0 : 0.4) // Fade out when disconnected
                .animation(.easeOut(duration: 0.15), value: isPressed)
        }
        .disabled(!isConnected) // Disable button interaction entirely
    }
}

// MARK: - Stop Button
struct StopButton: View {
    let action: () -> Void
    let isConnected: Bool
    
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard isConnected else { return }
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { isPressed = false }
        }) {
            Image(systemName: "xmark.octagon.fill")
                .font(.system(size: 40))
                .foregroundColor(CarTheme.accentRed)
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(CarTheme.panelGray)
                        .shadow(color: isPressed ? .black : .black.opacity(0.8), radius: 10, x: isPressed ? 0 : 5, y: isPressed ? 0 : 5)
                        .shadow(color: isPressed ? CarTheme.accentRed : .white.opacity(0.1), radius: 5, x: isPressed ? 0 : -3, y: isPressed ? 0 : -3)
                )
                // GLOW Effect on Press
                .glow(color: isPressed ? CarTheme.accentRed : .clear, radius: 12)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .opacity(isConnected ? 1.0 : 0.4)
                .animation(.easeOut(duration: 0.15), value: isPressed)
        }
        .disabled(!isConnected)
    }
}
