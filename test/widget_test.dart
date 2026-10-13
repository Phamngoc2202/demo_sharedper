import 'package:demo_sharedper/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('bộ đếm đọc và ghi bằng SharedPreferences', (tester) async {
    SharedPreferences.setMockInitialValues({'counter': 5});

    await tester.pumpWidget(const MaterialApp(home: CounterPage()));
    await tester.pumpAndSettle();
    expect(find.text('Giá trị: 5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Giá trị: 6'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('counter'), 6);

    // Tạo lại trang để kiểm tra giá trị được đọc từ preferences.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: CounterPage()));
    await tester.pumpAndSettle();
    expect(find.text('Giá trị: 6'), findsOneWidget);
  });
}
