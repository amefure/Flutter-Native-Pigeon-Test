import 'package:pigeon/pigeon.dart';

// 生成されるコードの設定（出力先を指定）
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/pigeon.g.dart',
  kotlinOut: 'android/app/src/main/kotlin/com/example/test_pigeon_app/Pigeon.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.example.test_pigeon_app'),
  swiftOut: 'ios/Runner/Pigeon.g.swift',
  dartPackageName: 'test_pigeon_app'
))

enum ChargingState {
  charging,
  discharging,
  full,
  unknown,
}

// 情報をまとめるクラス
class BatteryInfo {
  int level;
  ChargingState state;
  BatteryInfo({required this.level, required this.state});
}

// Flutter -> ネイティブ
@HostApi()
abstract class BatteryApi {
  BatteryInfo getBatteryInfo();
}

// ネイティブ -> Flutter
@FlutterApi()
abstract class BatteryFlutterApi {
  void onBatteryInfoChanged(BatteryInfo info);
}