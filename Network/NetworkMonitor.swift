//
//  NetworkMonitor.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//
import Network
import Combine

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                print("Network status changed: \(self?.isConnected == true ? "Connected" : "Disconnected")")
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }

    func checkNow() {
        let path = monitor.currentPath
        isConnected = path.status == .satisfied
        print("Manual check: \(isConnected ? "Connected" : "Disconnected")")
    }
}
