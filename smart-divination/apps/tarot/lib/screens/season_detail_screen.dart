import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/seasonal_wisdom.dart';
import '../data/seasonal_wisdom_data.dart';
import '../theme/tarot_theme.dart';
import 'sabbat_detail_screen.dart';

/// Detail screen for a specific season
/// Shows season info and its sabbats
class SeasonDetailScreen extends StatelessWidget {
  final Season season;
  final CommonStrings? strings;

  const SeasonDetailScreen({
    super.key,
    required this.season,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  Color _getSeasonColor() {
    return Color(int.parse(season.color.replaceFirst('#', '0xFF')));
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

  String _getAboutSeasonTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Sobre aquesta estació';
      case 'es':
        return 'Sobre esta estación';
      default:
        return 'About this season';
    }
  }

  String _getSeasonEnergyTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Energia de l\'estació';
      case 'es':
        return 'Energía de la estación';
      default:
        return 'Season\'s energy';
    }
  }

  String _getSignsElementsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Signes i Elements';
      case 'es':
        return 'Signos y Elementos';
      default:
        return 'Signs and Elements';
    }
  }

  String _getKeyThemesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Temes clau';
      case 'es':
        return 'Temas clave';
      default:
        return 'Key themes';
    }
  }

  String _getSabbatsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Sabbats d\'aquesta estació';
      case 'es':
        return 'Sabbats de esta estación';
      default:
        return 'Sabbats of this season';
    }
  }

  @override
  Widget build(BuildContext context) {
    final seasonColor = _getSeasonColor();
    final sabbats = SeasonalWisdomData.getSabbatsForSeason(season.id);
    final locale = _getLocale();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: seasonColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                season.getLocalizedName(locale),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
                      seasonColor,
                      seasonColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    season.icon,
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ArchetypeCard(
                  season: season,
                  seasonColor: seasonColor,
                  locale: locale,
                  title: _getArchetypeTitle(locale),
                ),
                const SizedBox(height: 16),
                _DescriptionCard(
                  season: season,
                  seasonColor: seasonColor,
                  locale: locale,
                  title: _getAboutSeasonTitle(locale),
                ),
                const SizedBox(height: 16),
                _EnergyCard(
                  season: season,
                  seasonColor: seasonColor,
                  locale: locale,
                  title: _getSeasonEnergyTitle(locale),
                ),
                const SizedBox(height: 16),
                _ElementsCard(
                  season: season,
                  seasonColor: seasonColor,
                  locale: locale,
                  title: _getSignsElementsTitle(locale),
                ),
                const SizedBox(height: 16),
                _ThemesCard(
                  season: season,
                  seasonColor: seasonColor,
                  locale: locale,
                  title: _getKeyThemesTitle(locale),
                ),
                const SizedBox(height: 24),
                Text(
                  _getSabbatsTitle(locale),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 16),
                ...sabbats.map((sabbat) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _SabbatCard(
                        sabbat: sabbat,
                        seasonColor: seasonColor,
                        locale: locale,
                        strings: strings,
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchetypeCard extends StatelessWidget {
  final Season season;
  final Color seasonColor;
  final String locale;
  final String title;

  const _ArchetypeCard({
    required this.season,
    required this.seasonColor,
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
              Icon(
                Icons.psychology,
                color: seasonColor,
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
            season.getArchetype(locale),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: seasonColor,
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
  final Season season;
  final Color seasonColor;
  final String locale;
  final String title;

  const _DescriptionCard({
    required this.season,
    required this.seasonColor,
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
              Icon(
                Icons.auto_stories,
                color: seasonColor,
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
            season.getDescription(locale),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _EnergyCard extends StatelessWidget {
  final Season season;
  final Color seasonColor;
  final String locale;
  final String title;

  const _EnergyCard({
    required this.season,
    required this.seasonColor,
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
              Icon(
                Icons.bolt,
                color: seasonColor,
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
            season.getEnergy(locale),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _ElementsCard extends StatelessWidget {
  final Season season;
  final Color seasonColor;
  final String locale;
  final String title;

  const _ElementsCard({
    required this.season,
    required this.seasonColor,
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
              Icon(
                Icons.local_fire_department,
                color: seasonColor,
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
            children: [
              ...season.getZodiacSigns(locale).asMap().entries.map((entry) {
                final index = entry.key;
                final sign = entry.value;
                final elements = season.getElements(locale);
                final element = index < elements.length ? elements[index] : '';
                return _ZodiacChip(
                  sign: sign,
                  element: element,
                  color: seasonColor,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZodiacChip extends StatelessWidget {
  final String sign;
  final String element;
  final Color color;

  const _ZodiacChip({
    required this.sign,
    required this.element,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sign,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.9),
            ),
          ),
          if (element.isNotEmpty)
            Text(
              element,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemesCard extends StatelessWidget {
  final Season season;
  final Color seasonColor;
  final String locale;
  final String title;

  const _ThemesCard({
    required this.season,
    required this.seasonColor,
    required this.locale,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final themes = season.getThemes(locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Icon(
                Icons.stars,
                color: seasonColor,
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
          ...themes.map((theme) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: seasonColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        theme,
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

class _SabbatCard extends StatelessWidget {
  final Sabbat sabbat;
  final Color seasonColor;
  final String locale;
  final CommonStrings? strings;

  const _SabbatCard({
    required this.sabbat,
    required this.seasonColor,
    required this.locale,
    this.strings,
  });

  Color _getSabbatColor() {
    return Color(int.parse(sabbat.color.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final sabbatColor = _getSabbatColor();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SabbatDetailScreen(
              sabbat: sabbat,
              strings: strings,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: sabbatColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  sabbat.icon,
                  style: TextStyle(fontSize: 24),
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
                        sabbat.getLocalizedName(locale),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: sabbat.isSolarFestival
                              ? Colors.amber.withValues(alpha: 0.2)
                              : Colors.deepOrange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sabbat.isSolarFestival ? '☀️' : '🔥',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${sabbat.date} • ${sabbat.getMeaning(locale)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
