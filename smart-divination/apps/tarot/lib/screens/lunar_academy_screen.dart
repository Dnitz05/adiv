import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/educational_content.dart';
import '../theme/tarot_theme.dart';
import '../screens/lunar_phases_screen.dart';
import '../screens/seasonal_wisdom_screen.dart';
import '../screens/planetary_days_screen.dart';
import '../screens/lunar_elements_screen.dart';
import '../screens/moon_signs_screen.dart';
import '../screens/special_events_screen.dart';

class LunarAcademyScreen extends StatelessWidget {
  const LunarAcademyScreen({
    super.key,
    required this.strings,
  });

  final CommonStrings strings;

  List<LunarAcademyCategory> _getCategories() {
    return [
      const LunarAcademyCategory(
        id: 'lunar_phases',
        icon: '🌙',
        title: {
          'en': 'Lunar Phases',
          'es': 'Fases Lunares',
          'ca': 'Fases Lunars',
        },
        subtitle: {
          'en': 'Explore the 8 moon phases and their wisdom',
          'es': 'Explora las 8 fases lunares y su sabiduría',
          'ca': 'Explora les 8 fases lunars i la seva saviesa',
        },
        color: '#6366F1', // Indigo
        itemCount: 8,
      ),
      const LunarAcademyCategory(
        id: 'seasonal_wisdom',
        icon: '🌸',
        title: {
          'en': 'Seasonal Wisdom',
          'es': 'Sabiduría Estacional',
          'ca': 'Saviesa Estacional',
        },
        subtitle: {
          'en': 'How the 4 seasons shape lunar energy',
          'es': 'Cómo las 4 estaciones moldean la energía lunar',
          'ca': 'Com les 4 estacions modelen l\'energia lunar',
        },
        color: '#10B981', // Emerald
        itemCount: 4,
      ),
      const LunarAcademyCategory(
        id: 'planetary_days',
        icon: '🪐',
        title: {
          'en': 'Planetary Days',
          'es': 'Días Planetarios',
          'ca': 'Dies Planetaris',
        },
        subtitle: {
          'en': 'The 7 days and their celestial rulers',
          'es': 'Los 7 días y sus regentes celestiales',
          'ca': 'Els 7 dies i els seus regents celestials',
        },
        color: '#8B5CF6', // Violet
        itemCount: 7,
      ),
      const LunarAcademyCategory(
        id: 'lunar_elements',
        icon: '🔥',
        title: {
          'en': 'Lunar Elements',
          'es': 'Elementos Lunares',
          'ca': 'Elements Lunars',
        },
        subtitle: {
          'en': 'Fire, Earth, Air & Water in moon cycles',
          'es': 'Fuego, Tierra, Aire y Agua en los ciclos lunares',
          'ca': 'Foc, Terra, Aire i Aigua en els cicles lunars',
        },
        color: '#F59E0B', // Amber
        itemCount: 4,
      ),
      const LunarAcademyCategory(
        id: 'moon_in_signs',
        icon: '♈',
        title: {
          'en': 'Moon in the Signs',
          'es': 'Luna en los Signos',
          'ca': 'Lluna en els Signes',
        },
        subtitle: {
          'en': 'The 12 zodiac signs and lunar influence',
          'es': 'Los 12 signos zodiacales y la influencia lunar',
          'ca': 'Els 12 signes zodiacals i la influència lunar',
        },
        color: '#EC4899', // Pink
        itemCount: 12,
      ),
      const LunarAcademyCategory(
        id: 'special_events',
        icon: '✨',
        title: {
          'en': 'Special Moon Events',
          'es': 'Eventos Lunares Especiales',
          'ca': 'Esdeveniments Lunars Especials',
        },
        subtitle: {
          'en': 'Eclipses, supermoons & rare phenomena',
          'es': 'Eclipses, superlunas y fenómenos raros',
          'ca': 'Eclipsis, superlunes i fenòmens rars',
        },
        color: '#F97316', // Orange
        itemCount: 6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories();
    final locale = strings.localeName;

    return Scaffold(
      backgroundColor: TarotTheme.veryLightLilacBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TarotTheme.deepNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getTitle(locale),
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🌙',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  _getHeaderTitle(locale),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getHeaderSubtitle(locale),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Categories grid
          ...categories.map(
            (category) => _CategoryCard(
              category: category,
              locale: locale,
              onTap: () => _navigateToCategory(context, category.id),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Acadèmia Lunar';
      case 'es':
        return 'Academia Lunar';
      default:
        return 'Lunar Academy';
    }
  }

  String _getHeaderTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Saviesa Lunar Ancestral';
      case 'es':
        return 'Sabiduría Lunar Ancestral';
      default:
        return 'Ancient Lunar Wisdom';
    }
  }

  String _getHeaderSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Descobreix els cicles, rituals i saviesa de la Lluna a través de tradicions astrològiques verificables.';
      case 'es':
        return 'Descubre los ciclos, rituales y sabiduría de la Luna a través de tradiciones astrológicas verificables.';
      default:
        return 'Discover the cycles, rituals and wisdom of the Moon through verifiable astrological traditions.';
    }
  }

  void _navigateToCategory(BuildContext context, String categoryId) {
    switch (categoryId) {
      case 'lunar_phases':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LunarPhasesScreen(strings: strings),
          ),
        );
        break;
      case 'seasonal_wisdom':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SeasonalWisdomScreen(strings: strings),
          ),
        );
        break;
      case 'planetary_days':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlanetaryDaysScreen(strings: strings),
          ),
        );
        break;
      case 'lunar_elements':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LunarElementsScreen(strings: strings),
          ),
        );
        break;
      case 'moon_in_signs':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoonSignsScreen(strings: strings),
          ),
        );
        break;
      case 'special_events':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SpecialEventsScreen(strings: strings),
          ),
        );
        break;
      default:
        // Coming soon for other categories
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getComingSoonMessage(strings.localeName),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  String _getComingSoonMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Aviat disponible!';
      case 'es':
        return '¡Próximamente!';
      default:
        return 'Coming soon!';
    }
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.locale,
    required this.onTap,
  });

  final LunarAcademyCategory category;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.getTitle(locale),
                            style: const TextStyle(
                              color: TarotTheme.deepNavy,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${category.itemCount}',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.getSubtitle(locale),
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
}
