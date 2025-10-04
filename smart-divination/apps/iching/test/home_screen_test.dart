import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_iching/main.dart';

void main() {
  testWidgets('renders I Ching placeholder', (tester) async {
    SharedPreferences.setMockInitialValues(const {});
    await tester.pumpWidget(const SmartIChingApp());
    await tester.pumpAndSettle();

    expect(find.text('Cast the coins to receive guidance.'), findsOneWidget);
    expect(find.byIcon(Icons.change_circle_outlined), findsOneWidget);
  });
}
