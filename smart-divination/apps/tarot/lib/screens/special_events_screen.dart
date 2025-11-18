import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/special_event.dart';
import '../data/special_events_data.dart';
import '../theme/tarot_theme.dart';
import 'special_event_detail_screen.dart';

/// Main screen for Special Moon Events
/// Eclipses, supermoons, blue moons and rare phenomena
class SpecialEventsScreen extends StatelessWidget {
  final CommonStrings? strings;

  const SpecialEventsScreen({
    super.key,
    this.strings,
  });

  String _getLocale(BuildContext context) {
    return strings?.localeName ?? 'en';
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Esdeveniments Lunars Especials';
      case 'es':
        return 'Eventos Lunares Especiales';
      default:
        return 'Special Moon Events';
    }
  }

  String _getWelcomeTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Esdeveniments Especials';
      case 'es':
        return 'Eventos Especiales';
      default:
        return 'Special Events';
    }
  }

  String _getWelcomeSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Eclipsis, superlunes i fenòmens rars';
      case 'es':
        return 'Eclipses, superlunas y fenómenos raros';
      default:
        return 'Eclipses, supermoons & rare phenomena';
    }
  }

  String _getWelcomeDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Més enllà dels cicles regulars de la Lluna, existeixen esdeveniments excepcionals que marquen moments de poder intensificat. Eclipsis que revelen veritats ocultes, superlunes que amplifiquen l\'energia, llunes blaves que ofereixen segones oportunitats, i fenòmens astrològics profunds com la Lluna Negra Lilith. Aquests esdeveniments són finestres de transformació potent.';
      case 'es':
        return 'Más allá de los ciclos regulares de la Luna, existen eventos excepcionales que marcan momentos de poder intensificado. Eclipses que revelan verdades ocultas, superlunas que amplifican la energía, lunas azules que ofrecen segundas oportunidades, y fenómenos astrológicos profundos como la Luna Negra Lilith. Estos eventos son ventanas de transformación potente.';
      default:
        return 'Beyond the Moon\'s regular cycles, there are exceptional events that mark moments of intensified power. Eclipses that reveal hidden truths, supermoons that amplify energy, blue moons that offer second chances, and profound astrological phenomena like Black Moon Lilith. These events are windows of potent transformation.';
    }
  }

  String _getIntensityGuideTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Guia d\'Intensitat';
      case 'es':
        return 'Guía de Intensidad';
      default:
        return 'Intensity Guide';
    }
  }

  String _getHighIntensityLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Alta';
      case 'es':
        return 'Alta';
      default:
        return 'High';
    }
  }

  String _getHighIntensityDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Eclipsis, Superlunes, Lluna Negra';
      case 'es':
        return 'Eclipses, Superlunas, Luna Negra';
      default:
        return 'Eclipses, Supermoons, Black Moon';
    }
  }

  String _getMediumIntensityLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Mitjana';
      case 'es':
        return 'Media';
      default:
        return 'Medium';
    }
  }

  String _getMediumIntensityDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lluna Blava';
      case 'es':
        return 'Luna Azul';
      default:
        return 'Blue Moon';
    }
  }

  String _getLowIntensityLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Baixa';
      case 'es':
        return 'Baja';
      default:
        return 'Low';
    }
  }

  String _getLowIntensityDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lluna Buida de Curs';
      case 'es':
        return 'Luna Vacía de Curso';
      default:
        return 'Void of Course Moon';
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
            _IntensityGuide(
              locale: locale,
              title: _getIntensityGuideTitle(locale),
              highLabel: _getHighIntensityLabel(locale),
              highDescription: _getHighIntensityDescription(locale),
              mediumLabel: _getMediumIntensityLabel(locale),
              mediumDescription: _getMediumIntensityDescription(locale),
              lowLabel: _getLowIntensityLabel(locale),
              lowDescription: _getLowIntensityDescription(locale),
            ),
            const SizedBox(height: 24),
            Text(
              _getTitle(locale),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            ...SpecialEventsData.events.map(
              (event) => _EventCard(
                event: event,
                locale: locale,
                strings: strings,
              ),
            ),
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
          color: const Color(0xFFF97316).withValues(alpha: 0.3),
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
                  color: const Color(0xFFF97316).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✨',
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

class _IntensityGuide extends StatelessWidget {
  final String locale;
  final String title;
  final String highLabel;
  final String highDescription;
  final String mediumLabel;
  final String mediumDescription;
  final String lowLabel;
  final String lowDescription;

  const _IntensityGuide({
    required this.locale,
    required this.title,
    required this.highLabel,
    required this.highDescription,
    required this.mediumLabel,
    required this.mediumDescription,
    required this.lowLabel,
    required this.lowDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
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
                Icons.info_outline,
                color: TarotTheme.cosmicAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _IntensityRow(
            color: const Color(0xFF8B0000),
            label: highLabel,
            description: highDescription,
          ),
          const SizedBox(height: 8),
          _IntensityRow(
            color: const Color(0xFF4169E1),
            label: mediumLabel,
            description: mediumDescription,
          ),
          const SizedBox(height: 8),
          _IntensityRow(
            color: const Color(0xFFB0C4DE),
            label: lowLabel,
            description: lowDescription,
          ),
        ],
      ),
    );
  }
}

class _IntensityRow extends StatelessWidget {
  final Color color;
  final String label;
  final String description;

  const _IntensityRow({
    required this.color,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final SpecialEvent event;
  final String locale;
  final CommonStrings? strings;

  const _EventCard({
    required this.event,
    required this.locale,
    this.strings,
  });

  Color _getEventColor() {
    return Color(int.parse(event.color.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final eventColor = _getEventColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecialEventDetailScreen(
                event: event,
                strings: strings,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: eventColor.withValues(alpha: 0.3),
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
                  color: eventColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    event.icon,
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
                            event.getLocalizedName(locale),
                            style: const TextStyle(
                              color: TarotTheme.deepNavy,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _IntensityBadge(
                          intensity: event.intensity,
                          locale: locale,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: TarotTheme.softBlueGrey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.frequency,
                            style: const TextStyle(
                              color: TarotTheme.softBlueGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: eventColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntensityBadge extends StatelessWidget {
  final String intensity;
  final String locale;

  const _IntensityBadge({
    required this.intensity,
    required this.locale,
  });

  Color _getIntensityColor() {
    switch (intensity) {
      case 'high':
        return const Color(0xFF8B0000);
      case 'medium':
        return const Color(0xFF4169E1);
      case 'low':
        return const Color(0xFFB0C4DE);
      default:
        return Colors.grey;
    }
  }

  String _getIntensityLabel() {
    switch (intensity) {
      case 'high':
        switch (locale) {
          case 'ca':
            return 'Alta';
          case 'es':
            return 'Alta';
          default:
            return 'High';
        }
      case 'medium':
        switch (locale) {
          case 'ca':
            return 'Mitjana';
          case 'es':
            return 'Media';
          default:
            return 'Medium';
        }
      case 'low':
        switch (locale) {
          case 'ca':
            return 'Baixa';
          case 'es':
            return 'Baja';
          default:
            return 'Low';
        }
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getIntensityColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getIntensityLabel(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
