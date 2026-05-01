import Flutter
import UIKit

// FlutterErrorをSwiftのErrorとして扱えるように拡張
extension FlutterError: Error {}

// 生成されたプロトコルを実装するクラスを作成
class BatteryApiImpl: BatteryApi {
    func getBatteryLevel() throws -> Int64 {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

        if device.batteryState == .unknown {
            throw FlutterError(code: "UNAVAILABLE", message: "Battery level not available.", details: nil)
        }
        let batteryLevel = device.batteryLevel
        return Int64(batteryLevel * 100)
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "samples.flutter.dev/battery"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller = window?.rootViewController as! FlutterViewController
    let api = BatteryApiImpl()
    BatteryApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)
    
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
