import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:common/shared/infrastructure/localization/app_localizations.dart';

void main() {
  testWidgets('loads AppLocalizations and resolves strings (ca)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ca'),
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).welcome),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Benvingut/da!'), findsOneWidget);
  });
}

