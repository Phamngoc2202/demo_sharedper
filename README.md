# Demo SharedPreferences trong Flutter

Đây là ví dụ bộ đếm trong file Word. Số đếm được lưu bằng key `counter`, nên khi đóng và mở lại ứng dụng, màn hình đọc lại giá trị đã lưu.

## Chạy thử

```sh
flutter pub get
flutter run -d web-server --web-port 8080
```

Mở `http://localhost:8080` bằng Chrome hoặc Edge thường. Khi chạy lại, dùng đúng cổng 8080 và cùng trình duyệt để dữ liệu Web vẫn thuộc cùng nơi lưu trữ. Lệnh `flutter run -d chrome` mở một hồ sơ Chrome tạm, nên dữ liệu có thể không còn trong lần chạy sau.

Nếu chạy trên Windows desktop, Flutter cần Windows Developer Mode để tạo symbolic link cho plugin. Sau đó dùng `flutter run -d windows`.

## Giải thích mã trong lib/main.dart

1. `main()` mở ứng dụng Flutter với màn hình `CounterPage`.
2. `initState()` gọi `_loadCounter()` khi màn hình xuất hiện.
3. `SharedPreferences.getInstance()` lấy đối tượng lưu trữ.
4. `getInt('counter') ?? 0` đọc số đã lưu; nếu key chưa có thì dùng 0.
5. Nhấn nút `+` gọi `_increment()`. Ứng dụng chờ `setInt('counter', nextValue)` ghi xong rồi cập nhật số trên màn hình bằng `setState()`.

File Word còn giới thiệu các kiểu String, double, bool và List<String>, cùng các hàm remove() và clear(). Mã demo hiện tại chỉ minh họa kiểu int đúng như ví dụ bộ đếm trong file.
