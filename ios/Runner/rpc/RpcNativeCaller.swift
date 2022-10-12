//
//  RpcNativeCaller.swift
//  Runner
//
//  Created by Jackin on 12.10.22.
//

import Foundation

typealias OnResult = (_ data: Any?) -> Void
typealias OnMethodCall = (_ method: String, _ data: Any?, _ result: @escaping OnResult) -> Void

class RpcNativeCaller {
    
//    private static let clazzMapping: [String: OnMethodCall] = [
//        EventBusProxy.CLASS : EventBusProxy.onMethodCall(_:data:result:),
//        AccountManagerProxy.CLASS : AccountManagerProxy.onMethodCall(_:data:result:)
//    ]
    
    private static let clazzMapping: [String: OnMethodCall] = [:]
    
    static func invoke(_ clazz: String, _ method: String, data: Any?, result: @escaping OnResult) {
        guard let callFunc = clazzMapping[clazz] else {
            return result(nil)
        }
        
        callFunc(method, data, result)
    }
    
}
