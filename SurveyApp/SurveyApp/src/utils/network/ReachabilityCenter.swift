//
//  ReachabilityCenter.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import Foundation
import SystemConfiguration

class ReachabilityCenter{
    class func isConnectedToInternet() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteRechability = withUnsafePointer(to: &zeroAddress, {$0.withMemoryRebound(to: sockaddr.self, capacity: 1){
            SCNetworkReachabilityCreateWithAddress(nil, $0)
            }}) else{
                return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteRechability, &flags){
            return false
        }
        if flags.isEmpty{
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
