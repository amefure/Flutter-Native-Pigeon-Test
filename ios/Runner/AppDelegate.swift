import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var batteryObserver: BatteryObserver?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        let api = BatteryApiImpl()
        BatteryApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)
        
        GeneratedPluginRegistrant.register(with: self)
        
        // バッテリー変化観測開始
        batteryObserver = BatteryObserver(binaryMessenger: controller.binaryMessenger)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
