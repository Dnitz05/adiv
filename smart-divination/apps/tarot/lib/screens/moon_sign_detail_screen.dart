import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/moon_sign.dart';
import '../theme/tarot_theme.dart';

/// Rich detail screen for a specific moon sign
/// Shows how the Moon expresses emotions in this sign
class MoonSignDetailScreen extends StatelessWidget {
  final MoonSign sign;
  final CommonStrings? strings;

  const MoonSignDetailScreen({
    super.key,
    required this.sign,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  Color _getSignColor() {
    return Color(int.parse(sign.color.replaceFirst('#', '0xFF')));
  }

  String _getMoonInSignTitle(String locale, String signName) {
    switch (locale) {
      case 'ca':
        return 'Lluna en $signName';
      case 'es':
        return 'Luna en $signName';
      default:
        return 'Moon in $signName';
    }
  }

  String _getArchetypeTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Arquetip';
      case 'es':
        return 'Arquetipo';
      default:
        return 'Archetype';
    }
  }

  String _getMoonHereTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Quan la Lluna està aquí';
      case 'es':
        return 'Cuando la Luna está aquí';
      default:
        return 'When the Moon is here';
    }
  }

  String _getEmotionalNatureTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Naturalesa Emocional';
      case 'es':
        return 'Naturaleza Emocional';
      default:
        return 'Emotional Nature';
    }
  }

  String _getEmotionExpressionTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Com s\'Expressen les Emocions';
      case 'es':
        return 'Cómo se Expresan las Emociones';
      default:
        return 'How Emotions Express';
    }
  }

  String _getRecommendedActivitiesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Activitats Recomanades';
      case 'es':
        return 'Actividades Recomendadas';
      default:
        return 'Recommended Activities';
    }
  }

  String _getTarotArcanumLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Arcà del Tarot';
      case 'es':
        return 'Arcano del Tarot';
      default:
        return 'Tarot Arcanum';
    }
  }

  String _getReflectionTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Per Reflexionar';
      case 'es':
        return 'Para Reflexionar';
      default:
        return 'For Reflection';
    }
  }

  String _getReflectionQuestion(String locale, String signName) {
    switch (locale) {
      case 'ca':
        return 'Com ressonen les qualitats de $signName amb el teu món emocional? Quan la Lluna passa per aquest signe, com pots honrar aquestes energies?';
      case 'es':
        return '¿Cómo resuenan las cualidades de $signName con tu mundo emocional? Cuando la Luna pasa por este signo, ¿cómo puedes honrar estas energías?';
      default:
        return 'How do the qualities of $signName resonate with your emotional world? When the Moon passes through this sign, how can you honor these energies?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();
    final signColor = _getSignColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: signColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getMoonInSignTitle(locale, sign.getLocalizedName(locale)),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    sign.symbol,
                    style: TextStyle(
                      fontSize: 16,
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
                      signColor,
                      signColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sign.icon,
                      style: TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            sign.element,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            sign.modality,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                _ArchetypeCard(sign: sign, signColor: signColor, locale: locale, title: _getArchetypeTitle(locale)),
                const SizedBox(height: 16),
                _DescriptionCard(sign: sign, signColor: signColor, locale: locale, title: _getMoonHereTitle(locale)),
                const SizedBox(height: 16),
                _EmotionalNatureCard(sign: sign, signColor: signColor, locale: locale, title: _getEmotionalNatureTitle(locale)),
                const SizedBox(height: 16),
                _MoonQualitiesCard(sign: sign, signColor: signColor, locale: locale, title: _getEmotionExpressionTitle(locale)),
                const SizedBox(height: 16),
                _BestActivitiesCard(sign: sign, signColor: signColor, locale: locale, title: _getRecommendedActivitiesTitle(locale)),
                const SizedBox(height: 16),
                _TarotCard(sign: sign, signColor: signColor, locale: locale, label: _getTarotArcanumLabel(locale)),
                const SizedBox(height: 16),
                _ReflectionCard(sign: sign, signColor: signColor, locale: locale, title: _getReflectionTitle(locale), question: _getReflectionQuestion(locale, sign.getLocalizedName(locale))),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchetypeCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String title;

  const _ArchetypeCard({
    required this.sign,
    required this.signColor,
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
          color: signColor.withValues(alpha: 0.3),
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
                Icons.psychology,
                color: signColor,
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
            sign.getArchetype(locale),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: signColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String title;

  const _DescriptionCard({
    required this.sign,
    required this.signColor,
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
          color: signColor.withValues(alpha: 0.3),
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
                color: signColor,
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
            sign.getDescription(locale),
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

class _EmotionalNatureCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String title;

  const _EmotionalNatureCard({
    required this.sign,
    required this.signColor,
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
          color: signColor.withValues(alpha: 0.3),
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
                Icons.favorite,
                color: signColor,
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
              color: signColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: signColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              sign.getEmotionalNature(locale),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: signColor.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoonQualitiesCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String title;

  const _MoonQualitiesCard({
    required this.sign,
    required this.signColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final qualities = sign.getMoonQualities(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: signColor.withValues(alpha: 0.3),
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
                Icons.nightlight_round,
                color: signColor,
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
                        color: signColor,
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

class _BestActivitiesCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String title;

  const _BestActivitiesCard({
    required this.sign,
    required this.signColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final activities = sign.getBestActivities(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: signColor.withValues(alpha: 0.3),
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
                color: signColor,
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
                      color: signColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: signColor.withValues(alpha: 0.9),
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

class _TarotCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String label;

  const _TarotCard({
    required this.sign,
    required this.signColor,
    required this.locale,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: signColor.withValues(alpha: 0.3),
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
              color: signColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.style,
              size: 32,
              color: signColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sign.tarotCard} (${sign.tarotNumber})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: signColor,
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

class _ReflectionCard extends StatelessWidget {
  final MoonSign sign;
  final Color signColor;
  final String locale;
  final String title;
  final String question;

  const _ReflectionCard({
    required this.sign,
    required this.signColor,
    required this.locale,
    required this.title,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: signColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: signColor.withValues(alpha: 0.3),
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
                color: signColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: signColor.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: signColor.withValues(alpha: 0.8),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
