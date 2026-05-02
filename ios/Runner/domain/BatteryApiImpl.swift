//
//  BatteryApiImpl.swift
//  Runner
//
//  Created by t&a on 2026/05/02.
//


// FlutterErrorをSwiftのErrorとして扱えるように拡張
extension FlutterError: @retroactive Error {}

// 生成されたプロトコルを実装するクラスを作成
class BatteryApiImpl: BatteryApi {
 
    func getBatteryInfo() throws -> BatteryInfo {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        return BatteryInfo(
            level: Int64(device.batteryLevel * 100),
            state: toPigeonState(device.batteryState)
        )
    }
    
    private func toPigeonState(_ state: UIDevice.BatteryState) -> ChargingState {
        switch state {
        case .charging:  return .charging
        case .full:      return .full
        case .unplugged: return .discharging
        default:         return .unknown
        }
    }
}
