//
//  BatteryObserver.swift
//  Runner
//
//  Created by t&a on 2026/05/02.
//

class BatteryObserver {
    private let flutterApi: BatteryFlutterApi
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.flutterApi = BatteryFlutterApi(binaryMessenger: binaryMessenger)
        
        // バッテリー監視を有効化
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // バッテリー残量が変化した時の通知を登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryInfoDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        
        // 2. バッテリー「状態（充電中など）」の変化を監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryInfoDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func batteryInfoDidChange(notification: Notification) {
        let api = BatteryApiImpl()
        guard let info = try? api.getBatteryInfo() else { return }
        flutterApi.onBatteryInfoChanged(info: info) { _ in }
    }
}

