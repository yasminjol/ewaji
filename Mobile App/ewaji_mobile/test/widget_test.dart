// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ewaji_mobile/main.dart';

void main() {
  testWidgets('App loads welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EwajiApp());

    // Verify that the welcome screen loads
    expect(find.text('EWAJI'), findsOneWidget);
    expect(find.text('Book the Look. Elevate the Culture.'), findsOneWidget);
  });
}
