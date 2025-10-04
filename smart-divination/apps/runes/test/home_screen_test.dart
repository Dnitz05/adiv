import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_runes/main.dart';

void main() {
  testWidgets('renders runes controls', (tester) async {
    SharedPreferences.setMockInitialValues(const {});
    await tester.pumpWidget(const SmartRunesApp());
    await tester.pumpAndSettle();

    expect(find.text('Allow reversed runes'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('Draw runes to receive guidance.'), findsOneWidget);
  });
}
