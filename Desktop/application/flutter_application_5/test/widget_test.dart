import 'package:flutter_test/flutter_test.dart';

// استيراد ملف main مباشرة
import '../lib/main.dart';

void main() {
  testWidgets('UniversityApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UniversityApp());
  });
}
