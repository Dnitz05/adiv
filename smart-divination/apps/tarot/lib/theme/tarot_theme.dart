import 'package:flutter/material.dart';

/// Professional tarot-themed design system
class TarotTheme {
  // Mystical color palette
  static const Color deepPurple = Color(0xFF2D1B4E);
  static const Color royalPurple = Color(0xFF4A2C6F);
  static const Color mysticViolet = Color(0xFF6B4B9E);
  static const Color celestialBlue = Color(0xFF5B7C99);
  static const Color moonGold = Color(0xFFD4AF37);
  static const Color starSilver = Color(0xFFE8E8E8);
  static const Color darkVoid = Color(0xFF1A0F2E);
  static const Color softGlow = Color(0xFFF5F0FF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: moonGold,
        secondary: mysticViolet,
        surface: deepPurple,
        background: darkVoid,
        onPrimary: darkVoid,
        onSecondary: starSilver,
        onSurface: starSilver,
        onBackground: starSilver,
      ),

      // Scaffold
      scaffoldBackgroundColor: darkVoid,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: deepPurple,
        foregroundColor: moonGold,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: moonGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: moonGold,
          letterSpacing: 2,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: deepPurple,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: moonGold.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: moonGold,
          letterSpacing: 1.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: starSilver,
          letterSpacing: 1.2,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: starSilver,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: moonGold,
          letterSpacing: 1,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: starSilver,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: starSilver,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: starSilver,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Lora',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: starSilver.withOpacity(0.9),
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: moonGold,
          letterSpacing: 0.5,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: moonGold,
          foregroundColor: darkVoid,
          elevation: 4,
          shadowColor: moonGold.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: moonGold,
          side: BorderSide(color: moonGold, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: deepPurple,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: moonGold.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mysticViolet),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: moonGold, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Lora',
          color: starSilver.withOpacity(0.8),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Lora',
          color: starSilver.withOpacity(0.5),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: moonGold.withOpacity(0.3),
        thickness: 1,
        space: 24,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: moonGold,
        size: 24,
      ),
    );
  }

  // Decorative gradients
  static LinearGradient get mysticGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        deepPurple,
        royalPurple,
        mysticViolet,
      ],
    );
  }

  static LinearGradient get celestialGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        darkVoid,
        deepPurple,
      ],
    );
  }

  // Box shadows
  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: moonGold.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> get glowShadow {
    return [
      BoxShadow(
        color: moonGold.withOpacity(0.3),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ];
  }
}
