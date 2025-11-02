// test/widget_test.dart
// Replace the entire content of your test file with this:

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the search bar exists
    expect(find.text('Search city...'), findsOneWidget);

    // Verify that location button exists
    expect(find.byIcon(Icons.my_location), findsOneWidget);

    // Verify that dark mode toggle exists
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });

  testWidgets('Search bar accepts input', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());

    // Find the search text field
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Enter text into the search field
    await tester.enterText(searchField, 'London');
    await tester.pump();

    // Verify the text was entered
    expect(find.text('London'), findsOneWidget);
  });
}