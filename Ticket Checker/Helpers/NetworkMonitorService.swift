//
//  NetworkMonitorService.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 25/10/2024.
//

import Foundation
import Network

class NetworkMonitorService {
    static let shared = NetworkMonitorService()
    private var monitor: NWPathMonitor?
    private var isMonitoring = false
    
    var isConnected: Bool = false
    var connectionDidChangeHandler: ((Bool) -> Void)?
    
    private init() {}
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor?.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            
            DispatchQueue.main.async {
                self?.connectionDidChangeHandler?(isConnected)
            }
        }
        
        monitor?.start(queue: queue)
        isMonitoring = true
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
        isMonitoring = false
    }
}
