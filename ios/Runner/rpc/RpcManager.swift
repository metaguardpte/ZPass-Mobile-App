//
//  RpcManager.swift
//  Runner
//
//  Created by Jackin on 12.10.22.
//

import Foundation
import Flutter
import RxSwift

class RpcManager {
    
    private let RPC_CHANNEL_ID = "com.zpassapp.channels.RpcManager"
    private let RPC_FUN_INVOKE = "invoke"
    private let RPC_FUN_NEW = "new_instance"
    private let RPC_FUN_RELEASE = "release_instance"

    private let RPC_PARAM_INSTANCE = "instance"
    private let RPC_PARAM_CLAZZ    = "clazz"
    private let RPC_PARAM_METHOD   = "method"
    private let RPC_PARAM_DATA     = "data"

    private let RPC_ON_CHANNEL_READY = "onChannelReady"
    private let RPC_RCV_CALLBACK = "onInvoked"
    
    private var channel: FlutterMethodChannel? = nil
    
    private var isChannelReadied = false
   
    private var readyCondition: NSCondition = {
       NSCondition()
    }()
    

    private func onChannelReady() {
        readyCondition.lock()
        isChannelReadied = true
        readyCondition.broadcast()
        readyCondition.unlock()
        LogUtil.instance.printLog(message: "RpcManager, onChannelReady")
    }
    
    private func onInvoke(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let params = call.arguments as? NSDictionary else {
            return result(nil)
        }
        
        guard let clazz = params[RPC_PARAM_CLAZZ] as? String,
              let method = params[RPC_PARAM_METHOD] as? String,
              let data = params[RPC_PARAM_DATA] else {
            return result(nil)
        }
        
        RpcNativeCaller.invoke(clazz, method, data: data) { resultData in
            result(resultData)
        }
    }
    
    private func call(method: String, request: [String: Any?]) -> Observable<String> {
        
        LogUtil.instance.printLog(message: "[zzz] call method: \(method), request: \(request)")
        return Single.create { [weak self] emitter in
            guard let ss = self, let ch = ss.channel else {
                emitter(Result.success(""))
                return Disposables.create()
            }
            ss.readyCondition.lock()
            if !ss.isChannelReadied {
                ss.readyCondition.wait()
            }
            //run
            DispatchQueue.main.async {
                ch.invokeMethod(method, arguments: request, result: { data in
                    LogUtil.instance.printLog(message: "[zzz] call method: \(method), request: \(request), result data => \(String(describing: data))")
                    guard let mapData = data as? NSDictionary,
                          let rawData = mapData[ss.RPC_PARAM_DATA] else {
                              emitter(Result.success(""))
                        return
                    }
                    
                    if let num = rawData as? NSNumber {
                        return emitter(Result.success(num.stringValue))
                    }
                    emitter(Result.success(rawData as? String ?? ""))
                })
            }
            ss.readyCondition.unlock()
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    func register(with registrar: FlutterPluginRegistrar) -> Void {
        channel = FlutterMethodChannel(
            name: RPC_CHANNEL_ID,
            binaryMessenger: registrar.messenger()
        )
        channel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            
            switch(call.method) {
            
            case self.RPC_ON_CHANNEL_READY:
                self.onChannelReady()
            
            case self.RPC_FUN_INVOKE:
                self.onInvoke(call: call, result: result)
            
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func initChannel(engine: FlutterEngine) {
        channel = FlutterMethodChannel(
            name: RPC_CHANNEL_ID,
            binaryMessenger: engine.binaryMessenger
        )
        channel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            
            switch(call.method) {
            
            case self.RPC_ON_CHANNEL_READY:
                self.onChannelReady()
            
            case self.RPC_FUN_INVOKE:
                self.onInvoke(call: call, result: result)
            
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    
    func createInstance(clazz: String, args: Any? = nil) -> Observable<NSNumber> {
        let params = [
            RPC_PARAM_CLAZZ: clazz,
            RPC_PARAM_DATA: args
        ]
        
        return call(method: RPC_FUN_NEW, request: params).map { (instanceId: String) in
            guard !instanceId.isEmpty else {
                return 0
            }
            return NSNumber(value: (instanceId as NSString).longLongValue)
        }
    }
    
    func releaseInstance(instanceId: NSNumber) -> Observable<Bool> {
        let params = [
            RPC_PARAM_INSTANCE: instanceId
        ]
        return call(method: RPC_FUN_RELEASE, request: params).map { _ in
            return true
        }
    }
    
    func invoke(clazz: String, method: String, args: Any? = nil) -> Observable<String> {
        var params: [String: Any] = [
            RPC_PARAM_CLAZZ: clazz,
            RPC_PARAM_METHOD: method
        ]
        
        if let data = args {
            params[RPC_PARAM_DATA] = data
        }
        
        return call(method: RPC_FUN_INVOKE, request: params)
    }
    
    func invoke(instanceId: NSNumber, method: String, args: Any? = nil) -> Observable<String> {
        
        var params: [String: Any] = [
            RPC_PARAM_INSTANCE: instanceId,
            RPC_PARAM_METHOD: method
        ]
        
        if let data = args {
            params[RPC_PARAM_DATA] = data
        }
        
        return call(method: RPC_FUN_INVOKE, request: params)
    }
    
    public static let shared: RpcManager = {
        RpcManager()
    }()
    
}
