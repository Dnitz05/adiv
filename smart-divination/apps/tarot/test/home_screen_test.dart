import 'package:flutter/material.dart';
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

  Future<void> _pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const SmartTarotApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('shows navigation after splash', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Spreads'), findsOneWidget);
  });

  testWidgets('chat tab shows welcome message when selected', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    expect(find.textContaining('tarot assistant'), findsOneWidget);
  });

  testWidgets('learn panel becomes visible when scrolling', (tester) async {
    await _pumpApp(tester);

    final listFinder = find.byType(ListView);
    expect(listFinder, findsOneWidget);

    await tester.drag(listFinder, const Offset(0, -800));
    await tester.pumpAndSettle();

    expect(find.text('Learn Tarot'), findsOneWidget);
  });
}