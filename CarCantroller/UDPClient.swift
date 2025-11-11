//
//  UDPClient.swift
//  CarCantroller
//
//  Created by Habishek on 31/10/25.
//

import Foundation
import Network
import Combine

// MARK: - UDP Client (Fixed for Heartbeat)
@MainActor
final class UDPClient: ObservableObject {
    
    private var connection: NWConnection?
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private let queue = DispatchQueue(label: "udp-client-queue")

    @Published var connectionActive = false // Only true after receiving 'ACK'
    @Published var lastStatus: String = "Idle"

    init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
    }

    func start() {
        let params = NWParameters.udp
        params.allowLocalEndpointReuse = true
        connection = NWConnection(host: host, port: port, using: params)

        connection?.stateUpdateHandler = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .ready:
                    // Connection is locally ready, but NOT confirmed by car yet.
                    self?.lastStatus = "Local Connection Ready. Waiting for car ACK..."
                    self?.connectionActive = false // Key Fix: Must wait for ACK
                case .failed(let error):
                    self?.connectionActive = false
                    self?.lastStatus = "Failed: \(error.localizedDescription)"
                default:
                    self?.connectionActive = false
                    self?.lastStatus = "Connecting..."
                }
            }
        }

        connection?.start(queue: queue)
        receiveNextMessage() // Start listening immediately
    }
    
    // MARK: - Send Data
    func send(_ text: String) {
        guard let connection else {
            lastStatus = "Error: No connection available."
            return
        }
        let data = Data(text.utf8)
        connection.send(content: data, completion: .contentProcessed { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.lastStatus = "Send Error: \(error.localizedDescription)"
                } else {
                    self?.lastStatus = "Sent: \(text)"
                }
            }
        })
    }
    
    // MARK: - Receive Heartbeat/Telemetry
    private func receiveNextMessage() {
        connection?.receiveMessage(completion: { [weak self] (data, context, isComplete, error) in
            guard let self = self else { return }

            if let data = data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8) ?? "Received non-text data"
                
                // Handle the received message
                DispatchQueue.main.async {
                    self.handleReceivedMessage(message)
                }
            }
            
            // Continue to listen for the next message as long as there's no fatal error
            if error == nil {
                self.receiveNextMessage()
            } else {
                DispatchQueue.main.async {
                    self.connectionActive = false
                    self.lastStatus = "Receive Fatal Error: \(error!.localizedDescription)"
                }
            }
        })
    }

    private func handleReceivedMessage(_ message: String) {
        if message.uppercased().contains("ACK") || message.uppercased().contains("OK") {
            // Heartbeat/Acknowledgment received! Car is confirmed alive.
            self.connectionActive = true
            self.lastStatus = "Car Connected & Active! (\(message))"
        } else {
            // Assume this is telemetry data (e.g., "Battery: 90%")
            self.lastStatus = "Telemetry: \(message)"
        }
    }
}
