import 'package:flutter_test/flutter_test.dart';
import 'package:citysense_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    // Mock SharedPreferences for Supabase persistence
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase with dummy values for testing
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'dummy-key',
    );
  });

  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CitySenseApp());

    // Verify that the loading screen appears
    expect(find.text('Loading...'), findsOneWidget);
  });
}
