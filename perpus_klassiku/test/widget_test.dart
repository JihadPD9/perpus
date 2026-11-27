import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:perpus_klassiku/main.dart';

void main() {
  testWidgets('splash sends a user without a token to login', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PerpusKlasikkuApp());
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Perpus Klasikku'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
