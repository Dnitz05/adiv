import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:common/shared/infrastructure/localization/app_localizations.dart';

void main() {
  runApp(const SmartIChingApp());
}

class SmartIChingApp extends StatelessWidget {
  const SmartIChingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle('iching'),
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const _IChingHomeScreen(),
    );
  }
}

class _IChingHomeScreen extends StatelessWidget {
  const _IChingHomeScreen();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle('iching'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.welcome, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start New Session'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              child: Text(t.settings),
            ),
          ],
        ),
      ),
    );
  }
}

