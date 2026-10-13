import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: CounterPage()));

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  SharedPreferences? _prefs;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // Đọc dữ liệu
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  // Ghi dữ liệu
  Future<void> _increment() async {
    final prefs = _prefs;
    if (prefs == null || _saving) return;

    final nextValue = _counter + 1;
    setState(() => _saving = true);
    try {
      await prefs.setInt('counter', nextValue);
      if (!mounted) return;
      setState(() => _counter = nextValue);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SharedPreferences')),
      body: Center(
        child: Text('Giá trị: $_counter', style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _prefs == null || _saving ? null : _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
