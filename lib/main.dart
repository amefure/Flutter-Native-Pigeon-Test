import 'package:flutter/material.dart';
import 'package:test_pigeon_app/pigeon/pigeon.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BatteryPage(),
    );
  }
}


class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

// BatteryFlutterApi（ネイティブからの通知）を受けるための実装
class MyBatteryHandler implements BatteryFlutterApi {
  final Function(BatteryInfo) onUpdate;
  MyBatteryHandler(this.onUpdate);

  @override
  void onBatteryInfoChanged(BatteryInfo info) {
    onUpdate(info);
  }
}

class _BatteryPageState extends State<BatteryPage> {
  BatteryInfo? _batteryInfo = null;
  final _hostApi = BatteryApi();

  @override
  void initState() {
    super.initState();
    // ネイティブからの通知を待ち受ける設定
    BatteryFlutterApi.setUp(MyBatteryHandler((info) {
      setState(() => _batteryInfo = info);
    }));

    // 初期値を取得
    _refreshBattery();
  }

  Future<void> _refreshBattery() async {
    final info = await _hostApi.getBatteryInfo();
    setState(() => _batteryInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pigeon Battery Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _batteryInfo?.level == null ? '取得中...' : 'バッテリー残量: ${_batteryInfo?.level}%',
              style: const TextStyle(fontSize: 24),
            ),

            Text(
              '状態：${_batteryInfo?.state}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshBattery,
              child: const Text('今すぐ更新'),
            ),
          ],
        ),
      ),
    );
  }
}