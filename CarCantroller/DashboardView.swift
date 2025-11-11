//
//  DashboardView.swift
//  CarCantroller
//
//  Created by Habishek on 31/10/25.
//

import SwiftUI

// MARK: - Dashboard
struct DashboardView: View {
    @ObservedObject var udp: UDPClient

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Background Neumorphic Panel
                RoundedRectangle(cornerRadius: 30)
                    .fill(CarTheme.panelGray)
                    .frame(width: 280, height: 100)
                    .shadow(color: .black.opacity(0.8), radius: 15, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.05), radius: 15, x: -5, y: -5)
                
                HStack(spacing: 15) {
                    // Status Indicator Ring with Pulse Animation
                    Circle()
                        .stroke(
                            udp.connectionActive ? CarTheme.accentGreen.opacity(0.4) : CarTheme.accentRed.opacity(0.4),
                            lineWidth: 4
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "bolt.fill")
                                .foregroundColor(udp.connectionActive ? CarTheme.accentGreen : CarTheme.accentRed)
                        )
                        .glow(color: udp.connectionActive ? CarTheme.accentGreen : CarTheme.accentRed, radius: 10)
                    
                    VStack(alignment: .leading) {
                        Text("SYSTEM STATUS")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(udp.connectionActive ? "LIVE: CONTROL ACTIVE" : "OFFLINE: AWAITING CAR")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(udp.connectionActive ? CarTheme.accentGreen : CarTheme.accentRed)
                    }
                }
            }
            
            Text("Last Update: \(udp.lastStatus)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}
