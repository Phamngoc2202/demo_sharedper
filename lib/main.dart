import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mở ứng dụng và hiển thị màn hình bộ đếm.
void main() => runApp(const MaterialApp(home: CounterPage()));

// StatefulWidget được dùng vì số đếm thay đổi khi đọc dữ liệu và khi nhấn nút.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // Số đang hiển thị trên màn hình. Khi vừa tạo State, tạm bắt đầu từ 0.
  int _counter = 0;

  // Đối tượng đọc/ghi dữ liệu; null trong lúc chưa tải xong.
  SharedPreferences? _prefs;

  // Khóa nút + trong lúc đang ghi để tránh hai lần ghi chồng lên nhau.
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Chỉ đọc giá trị đã lưu một lần khi màn hình được tạo.
    _loadCounter();
  }

  // Đọc số đã lưu từ thiết bị khi mở màn hình.
  Future<void> _loadCounter() async {
    // getInstance() lấy đối tượng SharedPreferences; vì bất đồng bộ nên dùng await.
    final prefs = await SharedPreferences.getInstance();

    // Nếu người dùng đã rời màn hình trong lúc chờ, không gọi setState().
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      // Cùng key 'counter' phải được dùng cho cả đọc và ghi.
      // Chưa có key này thì getInt() trả về null, nên dùng 0 làm mặc định.
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  // Tăng bộ đếm và ghi giá trị mới vào bộ nhớ cục bộ.
  Future<void> _increment() async {
    final prefs = _prefs;

    // Chưa đọc xong hoặc đang ghi thì bỏ qua lần nhấn này.
    if (prefs == null || _saving) return;

    final nextValue = _counter + 1;
    setState(() => _saving = true);
    try {
      // setInt(key, value) ghi số nguyên theo key 'counter'.
      // Plugin chọn nơi lưu theo nền tảng: Web dùng localStorage,
      // Android dùng SharedPreferences. Đây không phải file main.dart.
      await prefs.setInt('counter', nextValue);

      // Chờ lệnh ghi trả về rồi mới hiển thị số mới; kiểm tra State còn tồn tại.
      if (!mounted) return;
      setState(() => _counter = nextValue);
    } finally {
      // Mở lại nút + sau khi lệnh ghi kết thúc.
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // build() vẽ giao diện; setState() sẽ yêu cầu Flutter gọi lại hàm này.
    return Scaffold(
      appBar: AppBar(title: const Text('SharedPreferences')),
      body: Center(
        child: Text('Giá trị: $_counter', style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed = null làm nút tạm bị vô hiệu hóa.
        onPressed: _prefs == null || _saving ? null : _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
