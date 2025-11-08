import 'package:flutter/material.dart';
import '../theme/tarot_theme.dart';

/// Helper class per generar cards blanques amb l'estil Learn Panel
/// per màxima llegibilitat i cohesió visual
class LunarCardHelpers {
  LunarCardHelpers._();

  /// Crea una card blanca amb el disseny educatiu estàndard
  /// Similar a les cards del Learn Panel
  static Widget buildWhiteCard({
    required BuildContext context,
    required Widget child,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: Border.all(
          color: TarotTheme.brightBlue20,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.brightBlue10,
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }

  /// Crea una card amb header (icona + títol) i contingut
  static Widget buildCardWithHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
    String? subtitle,
    EdgeInsets? padding,
  }) {
    return buildWhiteCard(
      context: context,
      padding: padding ?? const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TarotTheme.brightBlue,
                  boxShadow: [
                    BoxShadow(
                      color: TarotTheme.brightBlue20,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: TarotTheme.softBlueGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  /// Estil de text per títols dins de cards blanques
  static TextStyle get cardTitleStyle => const TextStyle(
        color: TarotTheme.deepNavy,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      );

  /// Estil de text per subtítols dins de cards blanques
  static TextStyle get cardSubtitleStyle => const TextStyle(
        color: TarotTheme.softBlueGrey,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  /// Estil de text per contingut/body dins de cards blanques
  static TextStyle get cardBodyStyle => const TextStyle(
        color: TarotTheme.softBlueGrey,
        fontSize: 14,
        height: 1.5,
      );

  /// Estil de text per contingut petit dins de cards blanques
  static TextStyle get cardSmallStyle => const TextStyle(
        color: TarotTheme.softBlueGrey,
        fontSize: 12,
        height: 1.4,
      );

  /// Crea un badge petit per informació destacada
  static Widget buildBadge({
    required String text,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? TarotTheme.brightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Crea un divider subtil dins de cards blanques
  static Widget buildCardDivider() {
    return Container(
      height: 1,
      color: TarotTheme.brightBlue20,
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  /// Crea una llista d'items amb bullets dins de cards blanques
  static Widget buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    decoration: const BoxDecoration(
                      color: TarotTheme.brightBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: cardBodyStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
