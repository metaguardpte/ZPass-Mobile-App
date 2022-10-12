import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupPlugins()
        GeneratedPluginRegistrant.register(with: self)
        RpcManager.shared.register(with: self.registrar(forPlugin: "RpcManager")!)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //MARK: - Plugins
    private func setupPlugins() -> Void {
        #if DEBUG
        LogUtil.instance.setDebug(debug: true)
        #else
        LogUtil.instance.setDebug(debug: false)
        #endif
    }
}
