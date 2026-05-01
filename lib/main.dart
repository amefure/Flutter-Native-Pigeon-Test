import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _batteryLevel = '';

  Future<void> _getBatteryLevel() async {
    final api = BatteryApi();
    try {
      final int level = await api.getBatteryLevel();
      setState(() {
        _batteryLevel = 'Battery level: $level%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryLevel = "Error: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              _batteryLevel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getBatteryLevel,
        tooltip: 'バッテリーレベル取得',
        child: const Icon(Icons.add),
      ),
    );
  }
}
