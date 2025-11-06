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

  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartTarotApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(SmartTarotApp), findsOneWidget);
  });
}