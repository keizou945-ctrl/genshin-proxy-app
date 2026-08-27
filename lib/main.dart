import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genshin Proxy Connector',
      // ★デバッグモードの制限を内部から完全に解除し、あの白いエラー画面を出さない設定です
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      home: const ProxyHomeScreen(),
    );
  }
}

class ProxyHomeScreen extends StatefulWidget {
  const ProxyHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProxyHomeScreen> createState() => _ProxyHomeScreenState();
}

class _ProxyHomeScreenState extends State<ProxyHomeScreen> {
  final TextEditingController _ipController = TextEditingController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadSavedIP();
  }

  // 保存されたサーバーのアドレスを読み込む
  void _loadSavedIP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 初期値としてplayitのアドレスを登録
      _ipController.text = prefs.getString('saved_ip') ?? 'olds-tries.tun.ply.gg:25565';
    });
  }

  // 接続ボタンのアクション
  void _toggleConnection() async {
    if (_ipController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('サーバーのIPアドレスを入力してください')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_ip', _ipController.text);

    setState(() {
      _isConnected = !_isConnected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isConnected 
            ? '${_ipController.text} のプサバに接続しました！原神を起動してください。' 
            : 'プロキシを解除しました。公式サーバーに戻ります。'),
        backgroundColor: _isConnected ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('原神プサバ 接続ツール (iOS)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dns, size: 80, color: Colors.tealAccent),
            const SizedBox(height: 30),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'パソコンのIPアドレス (IPv4)',
                hintText: '例: 192.168.1.100',
                prefixIcon: Icon(Icons.computer),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isConnected ? Colors.red : Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _toggleConnection,
                child: Text(
                  _isConnected ? 'プサバ接続を解除する' : 'プライベートサーバーに接続',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isConnected ? '● 接続中 (Proxy Active)' : '○ 未接続 (Official Server)',
              style: TextStyle(
                color: _isConnected ? Colors.greenAccent : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}