import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/planetary_day.dart';
import '../data/planetary_days_data.dart';
import '../theme/tarot_theme.dart';
import 'planetary_day_detail_screen.dart';

/// Main screen for Planetary Days - The 7 weekdays and their celestial rulers
/// Based on the Chaldean Order
class PlanetaryDaysScreen extends StatelessWidget {
  final CommonStrings? strings;

  const PlanetaryDaysScreen({
    super.key,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Dies Planetaris';
      case 'es':
        return 'Días Planetarios';
      default:
        return 'Planetary Days';
    }
  }

  String _getThe7DaysTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Els 7 Dies de la Setmana';
      case 'es':
        return 'Los 7 Días de la Semana';
      default:
        return 'The 7 Days of the Week';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();
    final todaysPlanetaryDay = PlanetaryDaysData.getTodaysPlanetaryDay();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(_getTitle(locale)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeCard(locale: locale),
            const SizedBox(height: 24),
            _TodaysEnergyCard(planetaryDay: todaysPlanetaryDay, locale: locale),
            const SizedBox(height: 24),
            Text(
              _getThe7DaysTitle(locale),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            ...PlanetaryDaysData.days.map((day) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _DayCard(
                    day: day,
                    isToday: day.id == todaysPlanetaryDay.id,
                    locale: locale,
                    strings: strings,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String locale;

  const _WelcomeCard({required this.locale});

  String _getTitle() {
    switch (locale) {
      case 'ca':
        return 'Dies Planetaris';
      case 'es':
        return 'Días Planetarios';
      default:
        return 'Planetary Days';
    }
  }

  String _getSubtitle() {
    switch (locale) {
      case 'ca':
        return 'L\'Ordre Caldeu i els 7 governants celestials';
      case 'es':
        return 'El Orden Caldeo y los 7 gobernantes celestiales';
      default:
        return 'The Chaldean Order and the 7 celestial rulers';
    }
  }

  String _getDescription() {
    switch (locale) {
      case 'ca':
        return 'Cada dia de la setmana està governat per un planeta diferent, seguint l\'antic Ordre Caldeu. Aquesta tradició, que té més de 2000 anys, ens connecta amb les energies celestials que influeixen en el nostre dia a dia.';
      case 'es':
        return 'Cada día de la semana está gobernado por un planeta diferente, siguiendo el antiguo Orden Caldeo. Esta tradición, que tiene más de 2000 años, nos conecta con las energías celestiales que influyen en nuestro día a día.';
      default:
        return 'Each day of the week is ruled by a different planet, following the ancient Chaldean Order. This tradition, over 2000 years old, connects us with the celestial energies that influence our daily lives.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TarotTheme.cosmicAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🪐',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getDescription(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _TodaysEnergyCard extends StatelessWidget {
  final PlanetaryDay planetaryDay;
  final String locale;

  const _TodaysEnergyCard({
    required this.planetaryDay,
    required this.locale,
  });

  String _getTodayIs() {
    switch (locale) {
      case 'ca':
        return 'Avui és';
      case 'es':
        return 'Hoy es';
      default:
        return 'Today is';
    }
  }

  String _getDayOf() {
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

  @override
  Widget build(BuildContext context) {
    final dayColor = _getDayColor();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            dayColor,
            dayColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: dayColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                planetaryDay.icon,
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getTodayIs()} ${planetaryDay.getLocalizedName(locale)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_getDayOf()} ${planetaryDay.planet}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            planetaryDay.getThemes(locale),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final PlanetaryDay day;
  final bool isToday;
  final String locale;
  final CommonStrings? strings;

  const _DayCard({
    required this.day,
    required this.isToday,
    required this.locale,
    this.strings,
  });

  String _getTodayBadge() {
    switch (locale) {
      case 'ca':
        return 'AVUI';
      case 'es':
        return 'HOY';
      default:
        return 'TODAY';
    }
  }

  Color _getDayColor() {
    return Color(int.parse(day.color.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final dayColor = _getDayColor();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanetaryDayDetailScreen(
              planetaryDay: day,
              strings: strings,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isToday
                ? dayColor.withValues(alpha: 0.5)
                : dayColor.withValues(alpha: 0.3),
            width: isToday ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isToday
                  ? dayColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: isToday ? 12 : 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: dayColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  day.icon,
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        day.getLocalizedName(locale),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      if (isToday) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: dayColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getTodayBadge(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: dayColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.planet,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: dayColor.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day.getThemes(locale),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
