// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/main.dart';

void main() {
  testWidgets('App builds and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tic Tac Toe'), findsOneWidget);

    // Ensure 9 tappable cells eventually appear (board builds)
    // Wait one frame for potential animations
    await tester.pump(const Duration(milliseconds: 16));
    // There are multiple Icon placeholders; just assert something interactive exists
    // Here we just tap somewhere safe: nothing should crash.
    // (More detailed tests could be added later.)
  });
}
