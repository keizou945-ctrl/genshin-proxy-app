  void _loadSavedIP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 初期値としてマインクラフトの標準ポート「:25565」をくっつけておきます
      _ipController.text = prefs.getString('saved_ip') ?? 'olds-tries.tun.ply.gg:25565';
    });
  }