import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:smart_tarot/main.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      Supabase.instance.client;
    } catch (_) {
      await Supabase.initialize(
        url: 'https://example.supabase.co',
        anonKey: 'public-anon-key',
      );
    }
  });

  testWidgets('shows auth screen by default', (tester) async {
    await tester.pumpWidget(const SmartTarotApp());
    await tester.pumpAndSettle();

    expect(find.text('Sign in to Smart Tarot'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('forgot password link is rendered', (tester) async {
    await tester.pumpWidget(const SmartTarotApp());
    await tester.pumpAndSettle();

    expect(find.text('Forgot password?'), findsOneWidget);
  });
}
