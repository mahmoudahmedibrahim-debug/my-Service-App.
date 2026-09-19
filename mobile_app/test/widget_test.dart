// Basic smoke test: the app boots to the splash screen without throwing.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' as pv;

import 'package:shatably_app/app.dart';
import 'package:shatably_app/state/app_state.dart';

void main() {
  testWidgets('App boots to splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      pv.ChangeNotifierProvider(create: (_) => AppState(), child: const ShatablyApp()),
    );

    expect(find.text('شطبلي'), findsOneWidget);

    // Let the splash screen's navigation timer fire so no timer is left
    // pending when the test tears down.
    await tester.pump(const Duration(seconds: 3));
  });
}
