import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/lunar_element.dart';
import '../theme/tarot_theme.dart';

/// Rich detail screen for a specific lunar element
/// Shows all the wisdom, zodiac correspondences and lunar influence
class LunarElementDetailScreen extends StatelessWidget {
  final LunarElement element;
  final CommonStrings? strings;

  const LunarElementDetailScreen({
    super.key,
    required this.element,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  Color _getElementColor() {
    return Color(int.parse(element.color.replaceFirst('#', '0xFF')));
  }

  String _getElementEssenceTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Essència de l\'Element';
      case 'es':
        return 'Esencia del Elemento';
      default:
        return 'Element Essence';
    }
  }

  String _getElementEnergyTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Energia de l\'Element';
      case 'es':
        return 'Energía del Elemento';
      default:
        return 'Element Energy';
    }
  }

  String _getZodiacSignsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Els 3 Signes Zodiacals';
      case 'es':
        return 'Los 3 Signos Zodiacales';
      default:
        return 'The 3 Zodiac Signs';
    }
  }

  String _getQualitiesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Qualitats de l\'Element';
      case 'es':
        return 'Cualidades del Elemento';
      default:
        return 'Element Qualities';
    }
  }

  String _getMoonInfluenceTitle(String locale, String elementName) {
    switch (locale) {
      case 'ca':
        return 'Quan la Lluna està en $elementName';
      case 'es':
        return 'Cuando la Luna está en $elementName';
      default:
        return 'When the Moon is in $elementName';
    }
  }

  String _getTarotSuitLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Pal del Tarot';
      case 'es':
        return 'Palo del Tarot';
      default:
        return 'Tarot Suit';
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

  String _getReflectionQuestion(String locale, String elementName) {
    switch (locale) {
      case 'ca':
        return 'Quin és el teu element dominant? Com pots treballar amb l\'energia de $elementName quan la Lluna hi passa?';
      case 'es':
        return '¿Cuál es tu elemento dominante? ¿Cómo puedes trabajar con la energía de $elementName cuando la Luna pasa por él?';
      default:
        return 'What is your dominant element? How can you work with the energy of $elementName when the Moon passes through it?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();
    final elementColor = _getElementColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: elementColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                element.getLocalizedName(locale),
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
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      elementColor,
                      elementColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      element.icon,
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
                        element.tarotSuit,
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
                _DescriptionCard(element: element, elementColor: elementColor, locale: locale, title: _getElementEssenceTitle(locale)),
                const SizedBox(height: 16),
                _EnergyCard(element: element, elementColor: elementColor, locale: locale, title: _getElementEnergyTitle(locale)),
                const SizedBox(height: 16),
                _ZodiacSignsCard(element: element, elementColor: elementColor, locale: locale, title: _getZodiacSignsTitle(locale)),
                const SizedBox(height: 16),
                _QualitiesCard(element: element, elementColor: elementColor, locale: locale, title: _getQualitiesTitle(locale)),
                const SizedBox(height: 16),
                _MoonInfluenceCard(element: element, elementColor: elementColor, locale: locale, title: _getMoonInfluenceTitle(locale, element.getLocalizedName(locale))),
                const SizedBox(height: 16),
                _TarotConnectionCard(element: element, elementColor: elementColor, locale: locale, label: _getTarotSuitLabel(locale)),
                const SizedBox(height: 16),
                _ReflectionCard(element: element, elementColor: elementColor, locale: locale, title: _getReflectionTitle(locale), question: _getReflectionQuestion(locale, element.getLocalizedName(locale))),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String title;

  const _DescriptionCard({
    required this.element,
    required this.elementColor,
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
          color: elementColor.withValues(alpha: 0.3),
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
                color: elementColor,
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
            element.getDescription(locale),
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
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String title;

  const _EnergyCard({
    required this.element,
    required this.elementColor,
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
          color: elementColor.withValues(alpha: 0.3),
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
                color: elementColor,
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
              color: elementColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: elementColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.whatshot,
                  color: elementColor.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    element.getEnergyDescription(locale),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: elementColor.withValues(alpha: 0.9),
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

class _ZodiacSignsCard extends StatelessWidget {
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String title;

  const _ZodiacSignsCard({
    required this.element,
    required this.elementColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final signs = element.getZodiacSigns(locale);
    final modalities = element.getModalities(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: elementColor.withValues(alpha: 0.3),
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
                color: elementColor,
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
          ...List.generate(signs.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: elementColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: elementColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signs[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: elementColor.withValues(alpha: 0.9),
                      ),
                    ),
                    if (index < modalities.length) ...[
                      const SizedBox(height: 4),
                      Text(
                        modalities[index],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _QualitiesCard extends StatelessWidget {
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String title;

  const _QualitiesCard({
    required this.element,
    required this.elementColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final qualities = element.getQualities(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: elementColor.withValues(alpha: 0.3),
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
                Icons.auto_awesome,
                color: elementColor,
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
                        color: elementColor,
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

class _MoonInfluenceCard extends StatelessWidget {
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String title;

  const _MoonInfluenceCard({
    required this.element,
    required this.elementColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final influences = element.getMoonInfluence(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: elementColor.withValues(alpha: 0.3),
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
                color: elementColor,
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
          ...influences.asMap().entries.map((entry) {
            final index = entry.key;
            final influence = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: elementColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: elementColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      influence,
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

class _TarotConnectionCard extends StatelessWidget {
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String label;

  const _TarotConnectionCard({
    required this.element,
    required this.elementColor,
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
          color: elementColor.withValues(alpha: 0.3),
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
              color: elementColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.style,
              size: 32,
              color: elementColor,
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
                  element.tarotSuit,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: elementColor,
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
  final LunarElement element;
  final Color elementColor;
  final String locale;
  final String title;
  final String question;

  const _ReflectionCard({
    required this.element,
    required this.elementColor,
    required this.locale,
    required this.title,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: elementColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: elementColor.withValues(alpha: 0.3),
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
                color: elementColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: elementColor.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: elementColor.withValues(alpha: 0.8),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
