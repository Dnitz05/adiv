/// Smart Runes - Professional Nordic Rune Divination Application
/// 
/// This is the main entry point for the Smart Runes app, using the unified
/// divination engine with rune-specific configuration and branding.
library smart_runes;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../shared/contracts/divination_technique.dart';
import '../shared/infrastructure/app_config.dart';
import '../shared/infrastructure/theme_system.dart';
import '../shared/infrastructure/localization/app_localizations.dart';
import '../core/divination_app.dart';

/// Main entry point for Smart Runes application
void main() {
  runApp(
    const ProviderScope(
      child: SmartRunesApp(),
    ),
  );
}

/// Smart Runes Application - Technique-locked to Runes
class SmartRunesApp extends ConsumerWidget {
  /// Creates a Smart Runes application instance
  const SmartRunesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // App Identity
      title: 'Smart Runes',
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
      
      // Theming - Runes Green Palette
      theme: ThemeSystem.buildTheme(
        technique: DivinationTechnique.runes,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeSystem.buildTheme(
        technique: DivinationTechnique.runes,
        brightness: Brightness.dark,
      ),
      
      // App Router with technique injection
      routerConfig: DivinationApp.createRouter(
        technique: DivinationTechnique.runes,
      ),
    );
  }
}