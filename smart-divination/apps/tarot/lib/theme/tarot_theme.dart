import 'package:flutter/material.dart';

/// Minimalist neutral design system for tarot readings
class TarotTheme {
  // Mystical neutral palette - subtle cosmic theme
  static const Color deepNight =
      Color(0xFF0F0B1F); // Main background (deep blue-black)
  static const Color midnightBlue = Color(0xFF1A1530); // Card surfaces
  static const Color cosmicPurple = Color(0xFF2A2140); // Elevated surfaces
  static const Color twilightPurple = Color(0xFF3D3055); // Borders, dividers
  static const Color stardust =
      Color(0xFF8E8AA8); // Secondary text (purple-gray)
  static const Color moonlight = Color(0xFFF0EFF7); // Primary text
  static const Color subtleGold = Color(0xFFB8A280); // Accent (warm gold)
  static const Color cosmicAccent =
      Color(0xFFC084FC); // Secondary accent (bright vibrant purple)
  static const Color cosmicBlue = Color(0xFF6d82cd); // Quote accent / CTA
  static const Color starGlow = Color(0xFFE8E5F5); // High contrast text

  // Theme category colors - cosmic palette
  static const Color cosmicRose = Color(0xFFF48FB1); // Love theme
  static const Color cosmicAmber = Color(0xFFFFA726); // Career theme
  static const Color cosmicEmerald = Color(0xFF66BB6A); // Money theme
  static const Color cosmicOrchid = Color(0xFFAB47BC); // Personal growth theme
  static const Color cosmicTeal = Color(0xFF26A69A); // Decisions theme

  // Zodiac element colors - vibrant and distinctive
  static const Color elementFire = Color(0xFFFF6B35); // Fire element (orange-red)
  static const Color elementEarth = Color(0xFF2ECC71); // Earth element (green)
  static const Color elementAir = Color(0xFF54C5F8); // Air element (light blue)
  static const Color elementWater = Color(0xFF4A90E2); // Water element (blue)

  // Educational blue palette - friendly and approachable
  static const Color skyBlueLight = Color(0xFFFAFCFF); // Very light sky background
  static const Color skyBlueSoft = Color(0xFFF5FAFF); // Soft light blue alternative
  static const Color oceanBlue = Color(0xFFB3D9F2); // Medium ocean blue
  static const Color deepNavy = Color(0xFF1E3A5F); // Deep navy for primary text
  static const Color slateBlue = Color(0xFF475569); // Slate blue for secondary text
  static const Color brightBlue = Color(0xFF3B82F6); // Vibrant blue for icons/accents
  static const Color warmGold = Color(0xFFF59E0B); // Warm gold accent
  static const Color softBlueGrey = Color(0xFF64748B); // Soft blue-grey for descriptions

  // Lunar mystical palette - elegant lavender-blue tones
  static const Color lunarLavenderLight = Color(0xFFF0EBFF); // Soft lavender background
  static const Color lunarLavenderSoft = Color(0xFFE8E1FF); // Elegant lilac-blue
  static const Color lunarMysticShadow = Color(0x1A8B7FC4); // Mystical lavender shadow

  // Educational palette opacity variants
  static const Color brightBlue10 = Color(0x1A3B82F6); // 10% opacity
  static const Color brightBlue20 = Color(0x333B82F6); // 20% opacity
  static const Color brightBlue80 = Color(0xCC3B82F6); // 80% opacity
  static const Color deepNavy70 = Color(0xB31E3A5F); // 70% opacity
  static const Color slateBlue60 = Color(0x99475569); // 60% opacity
  static const Color skyBlueShadow = Color(0x1A3B82F6); // Soft blue shadow

  // Optimized opacity variants (avoid withOpacity() in builds)
  static const Color deepNightOverlay = Color(0xFA0F0B1F); // 98% opacity
  static const Color midnightBlueTransparent = Color(0xD91A1530); // 85% opacity
  static const Color midnightBlueAppBar = Color(0xF21A1530); // 95% opacity
  static const Color midnightBlue70 = Color(0xB31A1530); // 70% opacity
  static const Color cosmicAccentSubtle = Color(0x33C084FC); // 20% opacity
  static const Color cosmicAccentFaint = Color(0x1FC084FC); // 12% opacity
  static const Color cosmicAccent15 = Color(0x26C084FC); // 15% opacity
  static const Color cosmicAccent08 = Color(0x14C084FC); // 8% opacity
  static const Color cosmicAccent90 = Color(0xE6C084FC); // 90% opacity
  static const Color twilightPurpleLight = Color(0x993D3055); // 60% opacity
  static const Color twilightPurpleFaint = Color(0x333D3055); // 20% opacity
  static const Color twilightPurpleBorder = Color(0x4D3D3055); // 30% opacity
  static const Color stardustLight = Color(0xCC8E8AA8); // 80% opacity
  static const Color stardustFaint = Color(0x998E8AA8); // 60% opacity
  static const Color moonlightTransparent = Color(0xE6F0EFF7); // 90% opacity
  static const Color moonlight85 = Color(0xD9F0EFF7); // 85% opacity
  static const Color moonlight70 = Color(0xB3F0EFF7); // 70% opacity
  static const Color blackOverlay20 = Color(0x33000000); // 20% opacity
  static const Color blackOverlay30 = Color(0x4D000000); // 30% opacity
  static const Color white70 = Color(0xB3FFFFFF); // 70% opacity

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme - mystical and subtle
      colorScheme: ColorScheme.dark(
        primary: subtleGold,
        secondary: cosmicAccent,
        surface: midnightBlue,
        background: deepNight,
        onPrimary: deepNight,
        onSecondary: moonlight,
        onSurface: moonlight,
        onBackground: moonlight,
        error: Color(0xFFFF6B6B),
      ),

      // Scaffold
      scaffoldBackgroundColor: Colors.white,

      // AppBar - mystical and elegant
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: midnightBlue,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: midnightBlue,
          letterSpacing: 0.5,
        ),
      ),

      // Card - subtle mystical elevation
      cardTheme: CardThemeData(
        color: midnightBlue,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: cosmicAccent.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),

      // Text theme - neutral and readable
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: moonlight,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: moonlight,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: moonlight,
          letterSpacing: 0,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: starGlow,
          letterSpacing: 0.2,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: starGlow,
          letterSpacing: 0.15,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: moonlight,
          letterSpacing: 0.15,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: subtleGold,
          letterSpacing: 0.1,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: moonlight,
          letterSpacing: 0.15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: moonlight.withValues(alpha: 0.9),
          letterSpacing: 0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: stardust,
          letterSpacing: 0.1,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: subtleGold,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: stardust,
          letterSpacing: 0.5,
        ),
      ),

      // Filled button - mystical accent
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cosmicBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cosmicBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cosmicAccent,
          side: BorderSide(color: twilightPurple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: subtleGold,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Input decoration - mystical and elegant
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cosmicPurple,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: twilightPurple.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: twilightPurple.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cosmicBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFFF6B6B)),
        ),
        labelStyle: TextStyle(
          color: stardust,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: stardust.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: cosmicBlue,
          fontSize: 14,
        ),
      ),

      // Divider - subtle separation
      dividerTheme: DividerThemeData(
        color: twilightPurple.withValues(alpha: 0.2),
        thickness: 1,
        space: 16,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: stardust,
        size: 22,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cosmicPurple,
        contentTextStyle: TextStyle(color: moonlight, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: midnightBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cosmicAccent.withValues(alpha: 0.2)),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: moonlight,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: moonlight.withValues(alpha: 0.9),
          height: 1.5,
        ),
      ),

      // Progress indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cosmicAccent,
        circularTrackColor: twilightPurple.withValues(alpha: 0.3),
      ),
    );
  }

  // Mystical cosmic gradients
  static LinearGradient get subtleBackgroundGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0A0515), // Deep space
        deepNight,
        midnightBlue.withValues(alpha: 0.4),
        cosmicPurple.withValues(alpha: 0.2),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
  }

  static LinearGradient get cardGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        midnightBlue,
        cosmicPurple.withValues(alpha: 0.8),
      ],
    );
  }

  // Starry overlay gradient
  static LinearGradient get starryOverlay {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        cosmicAccent.withValues(alpha: 0.03),
        Colors.transparent,
        cosmicAccent.withValues(alpha: 0.02),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // Minimal shadows
  static List<BoxShadow> get subtleShadow {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> get elevatedShadow {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }

  // Utility colors
  static Color get accentColor => subtleGold;
  static Color get secondaryAccent => cosmicAccent;
  static Color get backgroundColor => deepNight;
  static Color get surfaceColor => midnightBlue;
  static Color get textColor => moonlight;
  static Color get subtleTextColor => stardust;

  /// Get zodiac element color by element name
  /// Supports multiple language variants (en, es, ca)
  static Color getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
      case 'foc':
      case 'fuego':
        return elementFire;
      case 'earth':
      case 'terra':
      case 'tierra':
        return elementEarth;
      case 'air':
      case 'aire':
        return elementAir;
      case 'water':
      case 'aigua':
      case 'agua':
        return elementWater;
      default:
        return brightBlue; // Fallback color
    }
  }
}
