// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:desh_crime_alert/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that HomeScreen shows its initial content.
    // As HomeScreen's body is currently: const Center(child: Text('HomeScreen Content - To be built')),
    // and AppBar title is 'Desh Crime Alert'
    expect(find.text('Desh Crime Alert'), findsOneWidget); // AppBar title in HomeScreen
    expect(find.text('HomeScreen Content - To be built'), findsOneWidget);

    // Example: Verify no counter widget is present as it was removed
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
