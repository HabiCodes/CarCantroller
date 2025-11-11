//
//  ContentView.swift
//  CarCantroller
//
//  Created by Habishek on 30/10/25.
//


import SwiftUI
import Network // Still needed for the UDPClient

// MARK: - Main View
struct ContentView: View {
    // Host/Port: ESP32 or Raspberry Pi default AP setup
    @StateObject private var udp = UDPClient(host: "192.168.4.1", port: 4210)

    var body: some View {
        ZStack {
            // 1. Dark background with a subtle glow
            LinearGradient(gradient: Gradient(colors: [CarTheme.darkBlue, .black]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Circle() // Central soft glow for effect
                .fill(CarTheme.backgroundGlow)
                .frame(width: 500, height: 500)
                .blur(radius: 100)
                .offset(y: -200)

            VStack(spacing: 30) {
                // Title
                Text("WhiteWalkers ")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(CarTheme.neonBlue)
                    .glow(color: CarTheme.neonBlue, radius: 15)

                // Status Panel
                DashboardView(udp: udp)
                
                // Directional Controls
                ControlPanelView(udp: udp)
            }
            .padding(.top, 40)
            .padding(.bottom, 40)
        }
        .onAppear {
            udp.start() // Initiate the connection on app launch
        }
    }
}
