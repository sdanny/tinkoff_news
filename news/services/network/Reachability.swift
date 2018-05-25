//
//  Reachability.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol ReachabilityProtocol {
    func isConnectedToNetwork() -> Bool
}

class Reachability: ReachabilityProtocol {
    
    func isConnectedToNetwork() -> Bool {
        let reachability: SCNetworkReachability?
        // define family
        if #available(iOS 9.0, *) { // IPv6
            var address = sockaddr_in6()
            
            address.sin6_len = UInt8(MemoryLayout.size(ofValue: address))
            address.sin6_family = sa_family_t(AF_INET6)
            
            reachability = withUnsafePointer(to: &address) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
        } else { // IPv4
            var address = sockaddr_in()
            
            address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
            address.sin_family = sa_family_t(AF_INET)
            
            reachability = withUnsafePointer(to: &address) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
        }
        guard reachability != nil else { return false }
        var flags = SCNetworkReachabilityFlags()
        // get flags
        if !SCNetworkReachabilityGetFlags(reachability!, &flags) { return false }
        // check flags
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
