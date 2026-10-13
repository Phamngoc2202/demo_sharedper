# Tìm hiểu SharedPreferences trong Flutter

Tài liệu này giải thích [demo bộ đếm](lib/main.dart) theo trình tự trong ảnh: **là gì → dùng khi nào → cách sử dụng → demo**.

## 1. SharedPreferences là gì? (What is it?)

`shared_preferences` là plugin Flutter lưu dữ liệu nhỏ trên thiết bị theo cặp **key – value**. Ví dụ, key `counter` có thể lưu giá trị số nguyên `3`. Khi ứng dụng mở lại, ta dùng cùng key để đọc số đã lưu.

Plugin hỗ trợ năm kiểu: `String`, `int`, `double`, `bool` và `List<String>`. Demo này dùng `int`. Dữ liệu có thể tồn tại sau khi đóng ứng dụng, nhưng plugin không dành cho dữ liệu quan trọng cần bảo đảm ghi bền vững hoặc dữ liệu nhạy cảm như mật khẩu. [Nguồn: tài liệu shared_preferences](https://pub.dev/packages/shared_preferences).

## 2. Được sử dụng khi nào?

Dùng cho dữ liệu **nhỏ và đơn giản**, chẳng hạn:

- Số đếm hoặc một điểm số đơn giản.
- Cài đặt giao diện như chế độ sáng/tối, ngôn ngữ.
- Cờ cho biết người dùng đã xem màn hình giới thiệu.

Nếu cần lưu nhiều bản ghi và tìm kiếm, lọc dữ liệu, nên dùng cơ sở dữ liệu. Không dùng giá trị lưu cục bộ làm bằng chứng xác thực đăng nhập.

## 3. Cách sử dụng

### 3.1. Khai báo thư viện / dependencies

Trong dự án này, [pubspec.yaml](pubspec.yaml) đã có:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.5.6
```

Nếu tạo dự án mới, có thể thêm bằng lệnh `flutter pub add shared_preferences`, sau đó chạy `flutter pub get`.

### 3.2. Khai báo package

Ở đầu [lib/main.dart](lib/main.dart), import plugin:

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

### 3.3. Tạo đối tượng

Code lấy đối tượng lưu trữ trong hàm `_loadCounter()`:

```dart
final prefs = await SharedPreferences.getInstance();
```

`getInstance()` chạy bất đồng bộ, vì vậy hàm gọi nó phải có `async` và dùng `await`. Biến `_prefs` giữ đối tượng này để nút `+` dùng lại khi ghi.

### 3.4. Đọc và ghi dữ liệu

**Đọc:** dùng `getInt` với đúng key `counter`:

```dart
_counter = prefs.getInt('counter') ?? 0;
```

Nếu chưa từng lưu key này, `getInt` trả về `null`. Toán tử `?? 0` cho bộ đếm bắt đầu từ 0.

**Ghi:** tăng số rồi lưu bằng `setInt`:

```dart
final nextValue = _counter + 1;
await prefs.setInt('counter', nextValue);
```

Đọc và ghi phải dùng **cùng key**. `await` chờ lệnh ghi hoàn tất trước khi demo cập nhật số trên màn hình.

## 4. Demo – minh họa các bước trên

### Khi mở ứng dụng

1. `main()` hiển thị `CounterPage`.
2. `initState()` gọi `_loadCounter()` một lần khi màn hình được tạo.
3. `_loadCounter()` lấy `SharedPreferences` và đọc key `counter`.
4. `setState()` cập nhật số trên giao diện. `if (!mounted) return` tránh cập nhật khi màn hình đã bị đóng.

### Khi nhấn nút +

1. `_increment()` tính `nextValue = _counter + 1`.
2. `setInt('counter', nextValue)` lưu số mới.
3. Sau khi ghi xong, `setState()` hiển thị số mới.
4. Biến `_saving` tạm khóa nút để tránh nhấn nhiều lần trong lúc đang ghi.

### Khi đóng rồi mở lại

| Lần chạy | Giá trị đọc từ key `counter` | Số hiển thị |
| --- | ---: | ---: |
| Lần đầu, chưa lưu | `null` → dùng `0` | 0 |
| Sau khi nhấn `+` ba lần | 3 | 3 |
| Đóng và mở lại ứng dụng | 3 | 3 |

Giá trị vẫn hiện là 3 vì `_loadCounter()` đọc lại dữ liệu từ `SharedPreferences`; biến `_counter` trong bộ nhớ được tạo mới khi app khởi động.

## 5. Chạy thử

Với ứng dụng Web, dùng một cổng cố định:

```sh
flutter run -d web-server --web-port 8080
```

Mở `http://localhost:8080` bằng Chrome hoặc Edge thường. Sau khi nhấn `+`, đóng trang rồi mở lại **cùng địa chỉ và cùng trình duyệt**. Dữ liệu Web được lưu theo địa chỉ trang, gồm cả cổng; `flutter run -d chrome` có thể dùng hồ sơ trình duyệt tạm nên không phù hợp để kiểm tra dữ liệu qua nhiều lần chạy. [Nguồn: Flutter](https://github.com/flutter/flutter/issues/189391), [MDN](https://developer.mozilla.org/en-US/docs/Glossary/Origin).

**Tóm tắt:** `getInstance()` lấy nơi lưu → `getInt()` đọc → `setInt()` ghi → mở lại app và `getInt()` đọc giá trị cũ.
