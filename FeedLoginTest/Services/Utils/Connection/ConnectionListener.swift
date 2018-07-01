//
//  ConnectionListener.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/20/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

enum ConnectionStatus {
    case online, offline, unknown
}

public var ConnectionLostNotification = NSNotification.Name("ConnectionLost")
public var ConnectionRestoredNotification = NSNotification.Name("ConnectionRestored")

class ConnectionListener {
    public static let shared = ConnectionListener()
    
    let reach = Reachability()
    
    private init() {
        listenToNetworkStatus()
    }
    
    
    func listenToNetworkStatus() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note: )), name: Notification.Name.reachabilityChanged, object: reach)
        
        do {
            try reach?.startNotifier()
        } catch {
            
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .none:
            postDisconnected()
        case .wifi, .cellular:
            postConnected()
        }
    }
    
    
    private func postDisconnected() {
        NotificationCenter.default.post(name: ConnectionLostNotification, object: nil)
    }
    
    private func postConnected() {
        NotificationCenter.default.post(name: ConnectionRestoredNotification, object: nil)
    }
    
    func getStatus() -> ConnectionStatus {
        guard let status = reach?.connection else {
            return .unknown
        }
        
        switch status {
        case .none:
            return .offline
        case .wifi, .cellular:
            return .online
        }
    }
    
    
}
