import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_weather_app/main.dart';

void main() {
  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(prefs: prefs));

    // Verify that the splash screen is shown initially
    expect(find.text('Weather App'), findsOneWidget);
    
    // Wait for animations to complete
    await tester.pumpAndSettle();
  });
}