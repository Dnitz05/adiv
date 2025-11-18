import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/seasonal_wisdom.dart';
import '../data/seasonal_wisdom_data.dart';
import '../theme/tarot_theme.dart';
import 'season_detail_screen.dart';

/// Main screen for Seasonal Wisdom - Wheel of the Year
/// Shows 4 seasons with navigation to sabbats
class SeasonalWisdomScreen extends StatelessWidget {
  final CommonStrings? strings;

  const SeasonalWisdomScreen({super.key, this.strings});

  String _getLocale(BuildContext context) {
    return strings?.localeName ?? 'en';
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Saviesa Estacional';
      case 'es':
        return 'Sabiduría Estacional';
      default:
        return 'Seasonal Wisdom';
    }
  }

  String _getWelcomeTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'La Roda de l\'Any';
      case 'es':
        return 'La Rueda del Año';
      default:
        return 'The Wheel of the Year';
    }
  }

  String _getWelcomeSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Explora el cicle etern de les estacions';
      case 'es':
        return 'Explora el ciclo eterno de las estaciones';
      default:
        return 'Explore the eternal cycle of the seasons';
    }
  }

  String _getWelcomeDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'La Roda de l\'Any és un cicle sagrat que honora el ritme de la natura i l\'energia canviant de les estacions. Cada estació porta el seu propi arquetip, energia i saviesa, connectant-nos amb els cicles més profunds de la vida.';
      case 'es':
        return 'La Rueda del Año es un ciclo sagrado que honra el ritmo de la naturaleza y la energía cambiante de las estaciones. Cada estación trae su propio arquetipo, energía y sabiduría, conectándonos con los ciclos más profundos de la vida.';
      default:
        return 'The Wheel of the Year is a sacred cycle that honors the rhythm of nature and the changing energy of the seasons. Each season carries its own archetype, energy and wisdom, connecting us with the deeper cycles of life.';
    }
  }

  String _getWheelCardTitle(String locale) {
    switch (locale) {
      case 'ca':
        return '8 Sabbats Sagrats';
      case 'es':
        return '8 Sabbats Sagrados';
      default:
        return '8 Sacred Sabbats';
    }
  }

  String _getWheelCardDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'La Roda de l\'Any celebra 8 moments clau: 4 festivals solars (solsticis i equinoccis) i 4 festivals de foc (punts intermedis). Junts, marquen els girs de l\'any i ens connecten amb els ritmes de la terra.';
      case 'es':
        return 'La Rueda del Año celebra 8 momentos clave: 4 festivales solares (solsticios y equinoccios) y 4 festivales de fuego (puntos intermedios). Juntos, marcan los giros del año y nos conectan con los ritmos de la tierra.';
      default:
        return 'The Wheel of the Year celebrates 8 key moments: 4 solar festivals (solstices and equinoxes) and 4 fire festivals (cross-quarter points). Together, they mark the turns of the year and connect us with the rhythms of the earth.';
    }
  }

  String _getSolarFestivalsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return '4 Festivals Solars';
      case 'es':
        return '4 Festivales Solares';
      default:
        return '4 Solar Festivals';
    }
  }

  String _getFireFestivalsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return '4 Festivals de Foc';
      case 'es':
        return '4 Festivales de Fuego';
      default:
        return '4 Fire Festivals';
    }
  }

  String _getSeasonsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Les Quatre Estacions';
      case 'es':
        return 'Las Cuatro Estaciones';
      default:
        return 'The Four Seasons';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale(context);

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
            _WelcomeCard(
              locale: locale,
              title: _getWelcomeTitle(locale),
              subtitle: _getWelcomeSubtitle(locale),
              description: _getWelcomeDescription(locale),
            ),
            const SizedBox(height: 24),
            _WheelOfTheYearCard(
              locale: locale,
              title: _getWheelCardTitle(locale),
              description: _getWheelCardDescription(locale),
              solarLabel: _getSolarFestivalsLabel(locale),
              fireLabel: _getFireFestivalsLabel(locale),
            ),
            const SizedBox(height: 24),
            Text(
              _getSeasonsTitle(locale),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            ...SeasonalWisdomData.seasons.map((season) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SeasonCard(season: season, locale: locale, strings: strings),
                )),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String locale;
  final String title;
  final String subtitle;
  final String description;

  const _WelcomeCard({
    required this.locale,
    required this.title,
    required this.subtitle,
    required this.description,
  });

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
                  '🌍',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
            description,
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

class _WheelOfTheYearCard extends StatelessWidget {
  final String locale;
  final String title;
  final String description;
  final String solarLabel;
  final String fireLabel;

  const _WheelOfTheYearCard({
    required this.locale,
    required this.title,
    required this.description,
    required this.solarLabel,
    required this.fireLabel,
  });

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
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SabbatTypeChip(
                icon: '☀️',
                label: solarLabel,
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              _SabbatTypeChip(
                icon: '🔥',
                label: fireLabel,
                color: Colors.deepOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SabbatTypeChip extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;

  const _SabbatTypeChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonCard extends StatelessWidget {
  final Season season;
  final String locale;
  final CommonStrings? strings;

  const _SeasonCard({
    required this.season,
    required this.locale,
    this.strings,
  });

  Color _getSeasonColor() {
    return Color(int.parse(season.color.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final seasonColor = _getSeasonColor();
    final sabbats = SeasonalWisdomData.getSabbatsForSeason(season.id);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeasonDetailScreen(
              season: season,
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
            color: seasonColor.withValues(alpha: 0.3),
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
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: seasonColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      season.icon,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        season.getLocalizedName(locale),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        season.getArchetype(locale),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: seasonColor.withValues(alpha: 0.8),
                              fontStyle: FontStyle.italic,
                            ),
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
            const SizedBox(height: 16),
            Text(
              season.getDescription(locale),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.5,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...season.getZodiacSigns(locale).map(
                      (sign) => _InfoChip(
                        label: sign,
                        color: seasonColor,
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: seasonColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: seasonColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    size: 18,
                    color: seasonColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sabbats.map((s) => s.name).join(' • '),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: seasonColor.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
