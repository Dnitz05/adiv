/// Smart Tarot - Professional Tarot Reading Application
/// 
/// This is the main entry point for the Smart Tarot app, using the unified
/// divination engine with tarot-specific configuration and branding.
library smart_tarot;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../shared/contracts/divination_technique.dart';
import '../shared/infrastructure/app_config.dart';
import '../shared/infrastructure/theme_system.dart';
import '../shared/infrastructure/localization/app_localizations.dart';
import '../core/divination_app.dart';

/// Main entry point for Smart Tarot application
void main() {
  runApp(
    const ProviderScope(
      child: SmartTarotApp(),
    ),
  );
}

/// Smart Tarot Application - Technique-locked to Tarot
class SmartTarotApp extends ConsumerWidget {
  /// Creates a Smart Tarot application instance
  const SmartTarotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // App Identity
      title: 'Smart Tarot',
      debugShowCheckedModeBanner: false,
      
      // Localization Support
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConfig.supportedLocales,
      locale: const Locale('en'), // Default to English
      
      // Theming - Tarot Purple Palette
      theme: ThemeSystem.buildTheme(
        technique: DivinationTechnique.tarot,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeSystem.buildTheme(
        technique: DivinationTechnique.tarot,
        brightness: Brightness.dark,
      ),
      
      // App Router with technique injection
      routerConfig: DivinationApp.createRouter(
        technique: DivinationTechnique.tarot,
      ),
    );
  }
}