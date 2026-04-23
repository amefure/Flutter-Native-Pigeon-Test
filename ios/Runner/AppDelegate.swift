import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "samples.flutter.dev/battery"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // ここから
    let controller = window?.rootViewController as! FlutterViewController

    let batteryChannel = FlutterMethodChannel(
        name: channelName,
        binaryMessenger: controller.binaryMessenger
    )

    batteryChannel.setMethodCallHandler { (call, result) in
        if call.method == "getBatteryLevel" {
            let level = self.getBatteryLevel()
            if true {
                result(level)
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Battery IOS info unavailable", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getBatteryLevel() -> Int {
      UIDevice.current.isBatteryMonitoringEnabled = true
      let batteryLevel = UIDevice.current.batteryLevel
      return Int(batteryLevel * 100)
  }
}
