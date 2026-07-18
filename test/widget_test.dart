import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aash_player/app/app.dart';

void main() {
  testWidgets('AashPlayerApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: AashPlayerApp()));

    // Verify that the shell text is displayed
    expect(find.text('Aash Player'), findsAtLeast(1));
  });
}
