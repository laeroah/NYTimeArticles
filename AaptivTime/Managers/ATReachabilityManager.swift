//
//  ATReachabilityManager.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/11/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import Foundation
import Reachability

/// This class monitors the reachability of the app
class ATReachabilityManager: NSObject {

    static let shared = ATReachabilityManager()

    let reachability = Reachability()!

    /// use KVO to observe this value to monitor connectivity
    @objc dynamic var connected = true

    deinit {
        print("????")
    }

    override init() {

        super.init()
        NotificationCenter
            .default.addObserver(self,
                                 selector: #selector(reachabilityChanged(note:)),
                                 name: .reachabilityChanged,
                                 object: reachability)


        do {
            try reachability.startNotifier()
        } catch {
            log.error("Unable to start reachability notifier")
        }
    }

    @objc func reachabilityChanged(note: Notification) {

        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            self.connected = true
        case .cellular:
            self.connected = true
        case .none:
            self.connected = false
        }
    }
}
