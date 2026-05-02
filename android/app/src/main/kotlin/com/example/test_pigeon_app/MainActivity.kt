package com.example.test_pigeon_app

import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter
import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import javax.naming.Context

class BatteryApiImpl(private val context: Context) : BatteryApi {

    override fun getBatteryInfo(): BatteryInfo {
        val intent = context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        return fromIntent(intent)
    }

    companion object {
        // IntentからPigeonのBatteryInfoクラスへ変換する共通ロジック
        fun fromIntent(intent: Intent?): BatteryInfo {
            val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1

            val state = when (status) {
                BatteryManager.BATTERY_STATUS_CHARGING -> ChargingState.CHARGING
                BatteryManager.BATTERY_STATUS_FULL -> ChargingState.FULL
                BatteryManager.BATTERY_STATUS_DISCHARGING -> ChargingState.DISCHARGING
                else -> ChargingState.UNKNOWN
            }

            return BatteryInfo(level.toLong(), state)
        }
    }
}
class MainActivity : FlutterActivity() {
    private var batteryFlutterApi: BatteryFlutterApi? = null

    // バッテリーの変化を監視するReceiver
    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val info = BatteryApiImpl.fromIntent(intent)
            batteryFlutterApi?.onBatteryInfoChanged(info) {}
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // 1. HostApi (Flutterからのリクエスト用) の登録
        BatteryApi.setUp(messenger, BatteryApiImpl(this))

        // 2. FlutterApi (ネイティブからFlutterへの通知用) の準備
        batteryFlutterApi = BatteryFlutterApi(messenger)

        // 3. バッテリー監視の開始
        registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(batteryReceiver)
    }
}