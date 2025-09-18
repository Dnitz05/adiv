import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_runes/main.dart';

void main() {
  testWidgets('Runes home shows Start New Session button (en)', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartRunesApp(),
      ),
    );

    // Let router settle
    await tester.pumpAndSettle();

    expect(find.text('Start New Session'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

