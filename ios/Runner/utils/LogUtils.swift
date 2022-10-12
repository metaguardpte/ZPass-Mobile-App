//
//  LogUtils.swift
//  Runner
//
//  Created by Jackin on 12.10.22.
//

import Foundation
import os

public class LogUtil : NSObject{
   
    static let instance = LogUtil()
    private var isDebug: Bool? = false
    
     @available(iOS 14.0, *)
     private lazy var logger = {
         return Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ZPass")
     }()
    
    private func debugMessage(_ msg: String) {
         if #available(iOS 14.0, *) {
             logger.debug("\(msg)")
         } else {
            NSLog("ZPass: %@", msg)
         }
    }
    
    func setDebug(debug: Bool){
        self.isDebug = debug
    }
    
    func printLog<T>(message: T,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        if(self.isDebug!){
            debugMessage("\((file as NSString).lastPathComponent)[\(line)], \(function): \(message)")
        }
    }
}
