# Demo SharedPreferences trong Flutter

Đây là ví dụ bộ đếm trong file Word. Số đếm được lưu bằng key `counter`, nên khi đóng và mở lại ứng dụng, màn hình đọc lại giá trị đã lưu.

## Chạy thử

```sh
flutter pub get
flutter run -d chrome
```

Nếu chạy trên Windows desktop, Flutter cần Windows Developer Mode để tạo symbolic link cho plugin. Sau đó dùng `flutter run -d windows`.

## Giải thích mã trong lib/main.dart

1. `main()` mở ứng dụng Flutter với màn hình `CounterPage`.
2. `initState()` gọi `_loadCounter()` khi màn hình xuất hiện.
3. `SharedPreferences.getInstance()` lấy đối tượng lưu trữ.
4. `getInt('counter') ?? 0` đọc số đã lưu; nếu key chưa có thì dùng 0.
5. Nhấn nút `+` gọi `_increment()`. `setState()` cập nhật số trên màn hình, còn `setInt('counter', _counter)` ghi số xuống bộ nhớ cục bộ.

File Word còn giới thiệu các kiểu String, double, bool và List<String>, cùng các hàm remove() và clear(). Mã demo hiện tại chỉ minh họa kiểu int đúng như ví dụ bộ đếm trong file.
