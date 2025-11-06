import 'package:common/l10n/common_strings.dart';
import 'package:flutter/material.dart';

import '../theme/tarot_theme.dart';

class LearnPanel extends StatelessWidget {
  const LearnPanel({
    super.key,
    required this.strings,
    required this.onNavigateToCards,
    required this.onNavigateToKnowledge,
    required this.onNavigateToSpreads,
    required this.onNavigateToAstrology,
    required this.onNavigateToKabbalah,
    required this.onNavigateToMoonPowers,
  });

  final CommonStrings strings;
  final VoidCallback onNavigateToCards;
  final VoidCallback onNavigateToKnowledge;
  final VoidCallback onNavigateToSpreads;
  final VoidCallback onNavigateToAstrology;
  final VoidCallback onNavigateToKabbalah;
  final VoidCallback onNavigateToMoonPowers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.cosmicAccent,
            TarotTheme.cosmicBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.cosmicAccent.withValues(alpha: 0.25),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLearnTitle(strings),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLearnSubtitle(strings),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: onNavigateToKnowledge,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.chevron_right, size: 18),
                label: Text(
                  _getHeaderActionLabel(strings),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.05,
            children: [
              _LearnCategory(
                icon: Icons.style,
                title: _getCardsTitle(strings),
                description: _getCardsDescription(strings),
                onTap: onNavigateToCards,
                accentColor: TarotTheme.cosmicAccent,
              ),
              _LearnCategory(
                icon: Icons.auto_awesome,
                title: _getAstrologyTitle(strings),
                description: _getAstrologyDescription(strings),
                onTap: onNavigateToAstrology,
                accentColor: TarotTheme.cosmicBlue,
              ),
              _LearnCategory(
                icon: Icons.grid_view,
                title: _getSpreadsTitle(strings),
                description: _getSpreadsDescription(strings),
                onTap: onNavigateToSpreads,
                accentColor: TarotTheme.cosmicPurple,
              ),
              _LearnCategory(
                icon: Icons.explore,
                title: _getFoundationsTitle(strings),
                description: _getFoundationsDescription(strings),
                onTap: onNavigateToKnowledge,
                accentColor: Colors.white,
                quickLinks: [
                  _QuickActionLink(label: _getKabbalahChipLabel(strings), onTap: onNavigateToKabbalah),
                  _QuickActionLink(label: _getMoonChipLabel(strings), onTap: onNavigateToMoonPowers),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _getLearnTitle(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Apren Tarot';
    case 'es':
      return 'Aprende Tarot';
    default:
      return 'Learn Tarot';
  }
}

String _getLearnSubtitle(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Biblioteca viva amb guies de tarot, astrologia i lluna';
    case 'es':
      return 'Biblioteca viva con guias de tarot, astrologia y luna';
    default:
      return 'A living library of tarot, astrology, and lunar wisdom';
  }
}

String _getHeaderActionLabel(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Explora';
    case 'es':
      return 'Explorar';
    default:
      return 'Explore';
  }
}

String _getCardsTitle(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Cartes Essentials';
    case 'es':
      return 'Cartas Esenciales';
    default:
      return 'Tarot Essentials';
  }
}

String _getCardsDescription(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Significats, simbologia i trucs per memoritzar arcans';
    case 'es':
      return 'Significados, simbolos y tips para memorizar arcanos';
    default:
      return 'Meanings, symbolism, and tips to internalise the arcana';
  }
}

String _getAstrologyTitle(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Astrologia';
    case 'es':
      return 'Astrologia';
    default:
      return 'Astrology';
  }
}

String _getAstrologyDescription(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Zodiac i fases lunars en dues capes: energia i calendari';
    case 'es':
      return 'Zodiaco y fases lunares en dos capas: energia y calendario';
    default:
      return 'Zodiac and lunar phases in two layers: energy plus timing';
  }
}

String _getSpreadsTitle(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Tirades i guies';
    case 'es':
      return 'Tiradas y guias';
    default:
      return 'Spreads & Guides';
  }
}

String _getSpreadsDescription(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Apren tirades clau i passa a passa per interpretar-les';
    case 'es':
      return 'Aprende tiradas clave y paso a paso para interpretarlas';
    default:
      return 'Learn signature spreads and the steps to interpret them';
  }
}

String _getFoundationsTitle(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Fonaments Mistcs';
    case 'es':
      return 'Fundamentos Misticos';
    default:
      return 'Mystic Foundations';
  }
}

String _getFoundationsDescription(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Histories, rituals i com unir Cabala i Lluna a les lectures';
    case 'es':
      return 'Historias, rituales y como unir Cabala y Luna en lecturas';
    default:
      return 'Stories, rituals, and weaving Kabbalah and lunar magic into spreads';
  }
}

String _getKabbalahChipLabel(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Camins Cabala';
    case 'es':
      return 'Caminos Cabala';
    default:
      return 'Kabbalah paths';
  }
}

String _getMoonChipLabel(CommonStrings strings) {
  switch (strings.localeName) {
    case 'ca':
      return 'Rituals Lluna';
    case 'es':
      return 'Rituales Luna';
    default:
      return 'Lunar rituals';
  }
}

class _LearnCategory extends StatelessWidget {
  const _LearnCategory({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.accentColor,
    this.quickLinks = const [],
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color? accentColor;
  final List<_QuickActionLink> quickLinks;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (accentColor ?? Colors.white).withValues(alpha: 0.28),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: quickLinks.isNotEmpty ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (quickLinks.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: quickLinks
                      .map(
                        (link) => _QuickLinkChip(
                          label: link.label,
                          onTap: link.onTap,
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionLink {
  const _QuickActionLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;
}

class _QuickLinkChip extends StatelessWidget {
  const _QuickLinkChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: Colors.white.withValues(alpha: 0.16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
