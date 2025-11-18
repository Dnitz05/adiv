import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/seasonal_wisdom.dart';
import '../theme/tarot_theme.dart';

/// Rich detail screen for a specific sabbat
/// Shows all the wisdom and traditions
class SabbatDetailScreen extends StatelessWidget {
  final Sabbat sabbat;
  final CommonStrings? strings;

  const SabbatDetailScreen({
    super.key,
    required this.sabbat,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  Color _getSabbatColor() {
    return Color(int.parse(sabbat.color.replaceFirst('#', '0xFF')));
  }

  String _getFestivalTypeLabel(String locale, bool isSolar) {
    if (isSolar) {
      switch (locale) {
        case 'ca':
          return '☀️ Festival Solar';
        case 'es':
          return '☀️ Festival Solar';
        default:
          return '☀️ Solar Festival';
      }
    } else {
      switch (locale) {
        case 'ca':
          return '🔥 Festival de Foc';
        case 'es':
          return '🔥 Festival de Fuego';
        default:
          return '🔥 Fire Festival';
      }
    }
  }

  String _getMeaningTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Significat';
      case 'es':
        return 'Significado';
      default:
        return 'Meaning';
    }
  }

  String _getAstrologicalCorrespondencesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Correspondències Astrològiques';
      case 'es':
        return 'Correspondencias Astrológicas';
      default:
        return 'Astrological Correspondences';
    }
  }

  String _getSolarPositionLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Posició Solar';
      case 'es':
        return 'Posición Solar';
      default:
        return 'Solar Position';
    }
  }

  String _getElementLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Element';
      case 'es':
        return 'Elemento';
      default:
        return 'Element';
    }
  }

  String _getModalityLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Modalitat';
      case 'es':
        return 'Modalidad';
      default:
        return 'Modality';
    }
  }

  String _getSabbatWisdomTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Saviesa del Sabbat';
      case 'es':
        return 'Sabiduría del Sabbat';
      default:
        return 'Sabbat Wisdom';
    }
  }

  String _getThemesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Temes per Explorar';
      case 'es':
        return 'Temas para Explorar';
      default:
        return 'Themes to Explore';
    }
  }

  String _getTraditionsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tradicions i Pràctiques';
      case 'es':
        return 'Tradiciones y Prácticas';
      default:
        return 'Traditions & Practices';
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

  String _getReflectionQuestion(String locale, String sabbatName) {
    switch (locale) {
      case 'ca':
        return 'Com pots honrar l\'energia de $sabbatName a la teva vida? Quins aspectes d\'aquest sabbat ressonen amb el teu moment actual?';
      case 'es':
        return '¿Cómo puedes honrar la energía de $sabbatName en tu vida? ¿Qué aspectos de este sabbat resuenan con tu momento actual?';
      default:
        return 'How can you honor the energy of $sabbatName in your life? What aspects of this sabbat resonate with your current moment?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();
    final sabbatColor = _getSabbatColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: sabbatColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sabbat.getLocalizedName(locale),
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
                    sabbat.date,
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
                      sabbatColor,
                      sabbatColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sabbat.icon,
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
                        _getFestivalTypeLabel(locale, sabbat.isSolarFestival),
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
                _MeaningCard(sabbat: sabbat, sabbatColor: sabbatColor, locale: locale, meaningTitle: _getMeaningTitle(locale)),
                const SizedBox(height: 16),
                _AstrologicalCard(
                  sabbat: sabbat,
                  sabbatColor: sabbatColor,
                  locale: locale,
                  title: _getAstrologicalCorrespondencesTitle(locale),
                  solarPositionLabel: _getSolarPositionLabel(locale),
                  elementLabel: _getElementLabel(locale),
                  modalityLabel: _getModalityLabel(locale),
                ),
                const SizedBox(height: 16),
                _DescriptionCard(sabbat: sabbat, sabbatColor: sabbatColor, locale: locale, title: _getSabbatWisdomTitle(locale)),
                const SizedBox(height: 16),
                _ThemesCard(sabbat: sabbat, sabbatColor: sabbatColor, locale: locale, title: _getThemesTitle(locale)),
                const SizedBox(height: 16),
                _TraditionsCard(sabbat: sabbat, sabbatColor: sabbatColor, locale: locale, title: _getTraditionsTitle(locale)),
                const SizedBox(height: 16),
                _ReflectionCard(
                  sabbat: sabbat,
                  sabbatColor: sabbatColor,
                  locale: locale,
                  title: _getReflectionTitle(locale),
                  question: _getReflectionQuestion(locale, sabbat.getLocalizedName(locale)),
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

class _MeaningCard extends StatelessWidget {
  final Sabbat sabbat;
  final Color sabbatColor;
  final String locale;
  final String meaningTitle;

  const _MeaningCard({
    required this.sabbat,
    required this.sabbatColor,
    required this.locale,
    required this.meaningTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sabbatColor.withValues(alpha: 0.3),
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
                color: sabbatColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                meaningTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sabbat.getMeaning(locale),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: sabbatColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _AstrologicalCard extends StatelessWidget {
  final Sabbat sabbat;
  final Color sabbatColor;
  final String locale;
  final String title;
  final String solarPositionLabel;
  final String elementLabel;
  final String modalityLabel;

  const _AstrologicalCard({
    required this.sabbat,
    required this.sabbatColor,
    required this.locale,
    required this.title,
    required this.solarPositionLabel,
    required this.elementLabel,
    required this.modalityLabel,
  });

  String _getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
      case 'foc':
        return '🔥';
      case 'earth':
      case 'terra':
        return '🌍';
      case 'air':
      case 'aire':
        return '💨';
      case 'water':
      case 'aigua':
        return '💧';
      default:
        return '✨';
    }
  }

  String _getModalityIcon(String modality) {
    switch (modality.toLowerCase()) {
      case 'cardinal':
        return '➡️';
      case 'fix':
      case 'fixed':
        return '⬛';
      case 'mutable':
        return '🔄';
      default:
        return '✨';
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
          color: sabbatColor.withValues(alpha: 0.3),
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
                color: sabbatColor,
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
          const SizedBox(height: 16),
          _AstroItem(
            icon: '☀️',
            label: solarPositionLabel,
            value: sabbat.getAstrological(locale),
            color: sabbatColor,
          ),
          const SizedBox(height: 12),
          _AstroItem(
            icon: _getElementIcon(sabbat.element),
            label: elementLabel,
            value: sabbat.element,
            color: sabbatColor,
          ),
          const SizedBox(height: 12),
          _AstroItem(
            icon: _getModalityIcon(sabbat.modality),
            label: modalityLabel,
            value: sabbat.modality,
            color: sabbatColor,
          ),
        ],
      ),
    );
  }
}

class _AstroItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _AstroItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final Sabbat sabbat;
  final Color sabbatColor;
  final String locale;
  final String title;

  const _DescriptionCard({
    required this.sabbat,
    required this.sabbatColor,
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
          color: sabbatColor.withValues(alpha: 0.3),
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
                color: sabbatColor,
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
            sabbat.getDescription(locale),
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

class _ThemesCard extends StatelessWidget {
  final Sabbat sabbat;
  final Color sabbatColor;
  final String locale;
  final String title;

  const _ThemesCard({
    required this.sabbat,
    required this.sabbatColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final themes = sabbat.getThemes(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sabbatColor.withValues(alpha: 0.3),
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
                Icons.spa,
                color: sabbatColor,
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: themes.map((theme) => _ThemeChip(
              theme: theme,
              color: sabbatColor,
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String theme;
  final Color color;

  const _ThemeChip({
    required this.theme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        theme,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _TraditionsCard extends StatelessWidget {
  final Sabbat sabbat;
  final Color sabbatColor;
  final String locale;
  final String title;

  const _TraditionsCard({
    required this.sabbat,
    required this.sabbatColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final traditions = sabbat.getTraditions(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sabbatColor.withValues(alpha: 0.3),
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
                Icons.celebration,
                color: sabbatColor,
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
          ...traditions.asMap().entries.map((entry) {
            final index = entry.key;
            final tradition = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: sabbatColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: sabbatColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tradition,
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
  final Sabbat sabbat;
  final Color sabbatColor;
  final String locale;
  final String title;
  final String question;

  const _ReflectionCard({
    required this.sabbat,
    required this.sabbatColor,
    required this.locale,
    required this.title,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: sabbatColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sabbatColor.withValues(alpha: 0.3),
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
                color: sabbatColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: sabbatColor.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: sabbatColor.withValues(alpha: 0.8),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
