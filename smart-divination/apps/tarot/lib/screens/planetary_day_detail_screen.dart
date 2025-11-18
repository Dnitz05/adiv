import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/planetary_day.dart';
import '../theme/tarot_theme.dart';

/// Rich detail screen for a specific planetary day
/// Shows all the wisdom, activities and correspondences
class PlanetaryDayDetailScreen extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final CommonStrings? strings;

  const PlanetaryDayDetailScreen({
    super.key,
    required this.planetaryDay,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  String _getDayOf(String locale) {
    switch (locale) {
      case 'ca':
        return 'Dia de';
      case 'es':
        return 'Día de';
      default:
        return 'Day of';
    }
  }

  Color _getDayColor() {
    return Color(int.parse(planetaryDay.color.replaceFirst('#', '0xFF')));
  }

  String _getTarotArcanumTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Arcà del Tarot';
      case 'es':
        return 'Arcano del Tarot';
      default:
        return 'Tarot Arcanum';
    }
  }

  String _getDailyWisdomTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Saviesa del Dia';
      case 'es':
        return 'Sabiduría del Día';
      default:
        return 'Daily Wisdom';
    }
  }

  String _getDayEnergyTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Energia del Dia';
      case 'es':
        return 'Energía del Día';
      default:
        return 'Day Energy';
    }
  }

  String _getPlanetaryQualitiesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Qualitats Planetàries';
      case 'es':
        return 'Cualidades Planetarias';
      default:
        return 'Planetary Qualities';
    }
  }

  String _getFavorableActivitiesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Activitats Favorables';
      case 'es':
        return 'Actividades Favorables';
      default:
        return 'Favorable Activities';
    }
  }

  String _getForReflectionTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Per Reflexionar';
      case 'es':
        return 'Para Reflexionar';
      default:
        return 'For Reflection';
    }
  }

  String _getReflectionText(String locale, String planet) {
    switch (locale) {
      case 'ca':
        return 'Com pots treballar amb l\'energia de $planet avui? Quines activitats d\'aquest dia ressonen amb el teu moment actual?';
      case 'es':
        return '¿Cómo puedes trabajar con la energía de $planet hoy? ¿Qué actividades de este día resuenan con tu momento actual?';
      default:
        return 'How can you work with the energy of $planet today? Which activities of this day resonate with your current moment?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayColor = _getDayColor();
    final locale = _getLocale();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: dayColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planetaryDay.getLocalizedName(locale),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_getDayOf(locale)} ${planetaryDay.planet}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      dayColor,
                      dayColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      planetaryDay.icon,
                      style: TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        planetaryDay.element,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TarotCard(
                  planetaryDay: planetaryDay,
                  dayColor: dayColor,
                  title: _getTarotArcanumTitle(locale),
                ),
                const SizedBox(height: 16),
                _DescriptionCard(
                  planetaryDay: planetaryDay,
                  dayColor: dayColor,
                  locale: locale,
                  title: _getDailyWisdomTitle(locale),
                ),
                const SizedBox(height: 16),
                _EnergyCard(
                  planetaryDay: planetaryDay,
                  dayColor: dayColor,
                  locale: locale,
                  title: _getDayEnergyTitle(locale),
                ),
                const SizedBox(height: 16),
                _QualitiesCard(
                  planetaryDay: planetaryDay,
                  dayColor: dayColor,
                  locale: locale,
                  title: _getPlanetaryQualitiesTitle(locale),
                ),
                const SizedBox(height: 16),
                _ActivitiesCard(
                  planetaryDay: planetaryDay,
                  dayColor: dayColor,
                  locale: locale,
                  title: _getFavorableActivitiesTitle(locale),
                ),
                const SizedBox(height: 16),
                _ReflectionCard(
                  planetaryDay: planetaryDay,
                  dayColor: dayColor,
                  title: _getForReflectionTitle(locale),
                  reflectionText: _getReflectionText(locale, planetaryDay.planet),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarotCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final Color dayColor;
  final String title;

  const _TarotCard({
    required this.planetaryDay,
    required this.dayColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dayColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dayColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.style,
              size: 32,
              color: dayColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${planetaryDay.tarotCard} (${planetaryDay.tarotNumber})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: dayColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final Color dayColor;
  final String locale;
  final String title;

  const _DescriptionCard({
    required this.planetaryDay,
    required this.dayColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dayColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: dayColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            planetaryDay.getDescription(locale),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  height: 1.7,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }
}

class _EnergyCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final Color dayColor;
  final String locale;
  final String title;

  const _EnergyCard({
    required this.planetaryDay,
    required this.dayColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dayColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt,
                color: dayColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dayColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: dayColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.whatshot,
                  color: dayColor.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    planetaryDay.getEnergyDescription(locale),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: dayColor.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QualitiesCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final Color dayColor;
  final String locale;
  final String title;

  const _QualitiesCard({
    required this.planetaryDay,
    required this.dayColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final qualities = planetaryDay.getQualities(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dayColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars,
                color: dayColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...qualities.map((quality) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dayColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        quality,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black87,
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ActivitiesCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final Color dayColor;
  final String locale;
  final String title;

  const _ActivitiesCard({
    required this.planetaryDay,
    required this.dayColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final activities = planetaryDay.getActivities(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dayColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                color: dayColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: dayColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: dayColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final Color dayColor;
  final String title;
  final String reflectionText;

  const _ReflectionCard({
    required this.planetaryDay,
    required this.dayColor,
    required this.title,
    required this.reflectionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dayColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dayColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: dayColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: dayColor.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reflectionText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dayColor.withValues(alpha: 0.8),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
