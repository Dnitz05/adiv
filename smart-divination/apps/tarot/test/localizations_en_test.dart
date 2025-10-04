import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:common/l10n/common_strings.dart';

void main() {
  testWidgets('loads CommonStrings and resolves strings (en)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: CommonStrings.localizationsDelegates,
        supportedLocales: CommonStrings.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => Text(CommonStrings.of(context).welcome),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
