package com.example.test_pigeon_app

import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import javax.naming.Context

// 1. 生成されたインターフェースを実装するクラスを作成
class BatteryApiImpl(val context: Context) : BatteryApi {
    override fun getBatteryLevel(): Long {
        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).toLong()
    }
}

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Pigeonのセットアップ
        val api = BatteryApiImpl(this)
        BatteryApi.setUp(flutterEngine.dartExecutor.binaryMessenger, api)
    }
}
