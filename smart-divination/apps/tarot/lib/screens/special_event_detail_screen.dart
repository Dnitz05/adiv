import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/special_event.dart';
import '../theme/tarot_theme.dart';

/// Detail screen for individual Special Moon Event
/// Shows scientific explanation, astrological meaning, practices
class SpecialEventDetailScreen extends StatelessWidget {
  final SpecialEvent event;
  final CommonStrings? strings;

  const SpecialEventDetailScreen({
    super.key,
    required this.event,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  Color _getEventColor() {
    return Color(int.parse(event.color.replaceFirst('#', '0xFF')));
  }

  String _getScientificExplanationTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Explicació Científica';
      case 'es':
        return 'Explicación Científica';
      default:
        return 'Scientific Explanation';
    }
  }

  String _getAstrologicalMeaningTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Significat Astrològic';
      case 'es':
        return 'Significado Astrológico';
      default:
        return 'Astrological Meaning';
    }
  }

  String _getLunarWisdomTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Saviesa Lunar';
      case 'es':
        return 'Sabiduría Lunar';
      default:
        return 'Lunar Wisdom';
    }
  }

  String _getSpiritualThemesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Temes Espirituals';
      case 'es':
        return 'Temas Espirituales';
      default:
        return 'Spiritual Themes';
    }
  }

  String _getPracticesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Pràctiques Recomanades';
      case 'es':
        return 'Prácticas Recomendadas';
      default:
        return 'Recommended Practices';
    }
  }

  String _getWhatToAvoidTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Què Evitar';
      case 'es':
        return 'Qué Evitar';
      default:
        return 'What to Avoid';
    }
  }

  String _getReflectionTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Per a la Reflexió';
      case 'es':
        return 'Para la Reflexión';
      default:
        return 'For Reflection';
    }
  }

  String _getReflectionText(String locale) {
    switch (locale) {
      case 'ca':
        return 'Aquests esdeveniments lunars especials són invitacions del cosmos per prestar atenció. Observa com et sents durant aquestes finestres de poder. Què et revelen sobre tu mateix? Quins canvis volen manifestar-se?';
      case 'es':
        return 'Estos eventos lunares especiales son invitaciones del cosmos para prestar atención. Observa cómo te sientes durante estas ventanas de poder. ¿Qué te revelan sobre ti mismo? ¿Qué cambios quieren manifestarse?';
      default:
        return 'These special lunar events are invitations from the cosmos to pay attention. Observe how you feel during these windows of power. What do they reveal about yourself? What changes want to manifest?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventColor = _getEventColor();
    final locale = _getLocale();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App Bar with Event Icon
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: eventColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.getLocalizedName(locale),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      eventColor,
                      eventColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    event.icon,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Info Card
                  _InfoCard(
                    event: event,
                    eventColor: eventColor,
                    locale: locale,
                  ),
                  const SizedBox(height: 16),

                  // Scientific Explanation
                  _SectionCard(
                    title: _getScientificExplanationTitle(locale),
                    icon: Icons.science,
                    color: eventColor,
                    child: Text(
                      event.getScientificExplanation(locale),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Astrological Meaning
                  _SectionCard(
                    title: _getAstrologicalMeaningTitle(locale),
                    icon: Icons.stars,
                    color: eventColor,
                    child: Text(
                      event.getAstrologicalMeaning(locale),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _SectionCard(
                    title: _getLunarWisdomTitle(locale),
                    icon: Icons.auto_stories,
                    color: eventColor,
                    child: Text(
                      event.getDescription(locale),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spiritual Themes
                  _SectionCard(
                    title: _getSpiritualThemesTitle(locale),
                    icon: Icons.psychology,
                    color: eventColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: event.getSpiritualThemes(locale).map((theme) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✨ ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: eventColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  theme,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Practices
                  _SectionCard(
                    title: _getPracticesTitle(locale),
                    icon: Icons.spa,
                    color: eventColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: event.getPractices(locale).asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: eventColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: eventColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // What to Avoid
                  _SectionCard(
                    title: _getWhatToAvoidTitle(locale),
                    icon: Icons.warning_amber,
                    color: const Color(0xFFDC2626),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: event.getWhatToAvoid(locale).map((avoid) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.close,
                                size: 16,
                                color: Color(0xFFDC2626),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  avoid,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reflection Card
                  _ReflectionCard(
                    eventColor: eventColor,
                    title: _getReflectionTitle(locale),
                    text: _getReflectionText(locale),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final SpecialEvent event;
  final Color eventColor;
  final String locale;

  const _InfoCard({
    required this.event,
    required this.eventColor,
    required this.locale,
  });

  String _getIntensityLabel() {
    switch (event.intensity) {
      case 'high':
        switch (locale) {
          case 'ca':
            return 'Alta Intensitat';
          case 'es':
            return 'Alta Intensidad';
          default:
            return 'High Intensity';
        }
      case 'medium':
        switch (locale) {
          case 'ca':
            return 'Intensitat Mitjana';
          case 'es':
            return 'Intensidad Media';
          default:
            return 'Medium Intensity';
        }
      case 'low':
        switch (locale) {
          case 'ca':
            return 'Baixa Intensitat';
          case 'es':
            return 'Baja Intensidad';
          default:
            return 'Low Intensity';
        }
      default:
        return '';
    }
  }

  String _getTypeLabel() {
    switch (event.type) {
      case 'eclipse':
        switch (locale) {
          case 'ca':
            return 'Eclipsi';
          case 'es':
            return 'Eclipse';
          default:
            return 'Eclipse';
        }
      case 'phenomenon':
        switch (locale) {
          case 'ca':
            return 'Fenomen Lunar';
          case 'es':
            return 'Fenómeno Lunar';
          default:
            return 'Lunar Phenomenon';
        }
      case 'astrological':
        switch (locale) {
          case 'ca':
            return 'Punt Astrològic';
          case 'es':
            return 'Punto Astrológico';
          default:
            return 'Astrological Point';
        }
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16,
                      color: eventColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getTypeLabel(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: eventColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: TarotTheme.softBlueGrey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.frequency,
                        style: const TextStyle(
                          fontSize: 13,
                          color: TarotTheme.softBlueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: eventColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getIntensityLabel(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: eventColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  final Color eventColor;
  final String title;
  final String text;

  const _ReflectionCard({
    required this.eventColor,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            eventColor.withValues(alpha: 0.1),
            eventColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: eventColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: eventColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: eventColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
