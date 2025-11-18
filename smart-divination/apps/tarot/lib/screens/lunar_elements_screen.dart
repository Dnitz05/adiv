import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/lunar_element.dart';
import '../data/lunar_elements_data.dart';
import '../theme/tarot_theme.dart';
import 'lunar_element_detail_screen.dart';

/// Main screen for Lunar Elements - The 4 classical elements
/// Fire, Earth, Air, Water and their connection to lunar cycles
class LunarElementsScreen extends StatelessWidget {
  final CommonStrings? strings;

  const LunarElementsScreen({
    super.key,
    this.strings,
  });

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Elements Lunars';
      case 'es':
        return 'Elementos Lunares';
      default:
        return 'Lunar Elements';
    }
  }

  String _getThe4ElementsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Els 4 Elements';
      case 'es':
        return 'Los 4 Elementos';
      default:
        return 'The 4 Elements';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();

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
            _ElementalWheelCard(locale: locale),
            const SizedBox(height: 24),
            Text(
              _getThe4ElementsTitle(locale),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            ...LunarElementsData.elements.map((element) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ElementCard(
                    element: element,
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
        return 'Els 4 Elements';
      case 'es':
        return 'Los 4 Elementos';
      default:
        return 'The 4 Elements';
    }
  }

  String _getSubtitle() {
    switch (locale) {
      case 'ca':
        return 'Foc, Terra, Aire i Aigua en els cicles lunars';
      case 'es':
        return 'Fuego, Tierra, Aire y Agua en los ciclos lunares';
      default:
        return 'Fire, Earth, Air and Water in lunar cycles';
    }
  }

  String _getDescription() {
    switch (locale) {
      case 'ca':
        return 'Els quatre elements clàssics formen la base de l\'astrologia i el tarot. Cada element governa tres signes zodiacals i representa una energia fonamental de la vida. Quan la Lluna passa per cada element, ens connecta amb aquestes energies primordials.';
      case 'es':
        return 'Los cuatro elementos clásicos forman la base de la astrología y el tarot. Cada elemento gobierna tres signos zodiacales y representa una energía fundamental de la vida. Cuando la Luna pasa por cada elemento, nos conecta con estas energías primordiales.';
      default:
        return 'The four classical elements form the foundation of astrology and tarot. Each element governs three zodiac signs and represents a fundamental life energy. When the Moon passes through each element, it connects us with these primordial energies.';
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
                  '⚛️',
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

class _ElementalWheelCard extends StatelessWidget {
  final String locale;

  const _ElementalWheelCard({required this.locale});

  String _getTitle() {
    switch (locale) {
      case 'ca':
        return 'La Roda Elemental';
      case 'es':
        return 'La Rueda Elemental';
      default:
        return 'The Elemental Wheel';
    }
  }

  String _getDescription() {
    switch (locale) {
      case 'ca':
        return 'Els elements estan connectats amb els pals del tarot, els signes zodiacals i les modalitats astrològiques. Aquesta saviesa ancestral ens ajuda a comprendre les energies que flueixen a través dels cicles lunars.';
      case 'es':
        return 'Los elementos están conectados con los palos del tarot, los signos zodiacales y las modalidades astrológicas. Esta sabiduría ancestral nos ayuda a comprender las energías que fluyen a través de los ciclos lunares.';
      default:
        return 'The elements are connected to tarot suits, zodiac signs and astrological modalities. This ancestral wisdom helps us understand the energies that flow through lunar cycles.';
    }
  }

  String _getSuitName(String elementName) {
    // Bastos, Oros, Espases, Copes are same in CA/ES
    if (elementName == '🔥') {
      switch (locale) {
        case 'ca':
        case 'es':
          return 'Bastos';
        default:
          return 'Wands';
      }
    } else if (elementName == '🌍') {
      switch (locale) {
        case 'ca':
        case 'es':
          return 'Oros';
        default:
          return 'Pentacles';
      }
    } else if (elementName == '💨') {
      switch (locale) {
        case 'ca':
        case 'es':
          return 'Espases';
        default:
          return 'Swords';
      }
    } else { // 💧
      switch (locale) {
        case 'ca':
        case 'es':
          return 'Copes';
        default:
          return 'Cups';
      }
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
          Text(
            _getTitle(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            _getDescription(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TarotSuitChip(
                  element: '🔥',
                  suit: _getSuitName('🔥'),
                  color: Color(0xFFFF4500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TarotSuitChip(
                  element: '🌍',
                  suit: _getSuitName('🌍'),
                  color: Color(0xFF228B22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _TarotSuitChip(
                  element: '💨',
                  suit: _getSuitName('💨'),
                  color: Color(0xFF87CEEB),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TarotSuitChip(
                  element: '💧',
                  suit: _getSuitName('💧'),
                  color: Color(0xFF4169E1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarotSuitChip extends StatelessWidget {
  final String element;
  final String suit;
  final Color color;

  const _TarotSuitChip({
    required this.element,
    required this.suit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(element, style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            suit,
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

class _ElementCard extends StatelessWidget {
  final LunarElement element;
  final String locale;
  final CommonStrings? strings;

  const _ElementCard({
    required this.element,
    required this.locale,
    this.strings,
  });

  Color _getElementColor() {
    return Color(int.parse(element.color.replaceFirst('#', '0xFF')));
  }

  String _getTarotLabel() {
    switch (locale) {
      case 'ca':
        return 'Tarot';
      case 'es':
        return 'Tarot';
      default:
        return 'Tarot';
    }
  }

  @override
  Widget build(BuildContext context) {
    final elementColor = _getElementColor();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LunarElementDetailScreen(
              element: element,
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
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: elementColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      element.icon,
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
                        element.getLocalizedName(locale),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_getTarotLabel()}: ${element.tarotSuit}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: elementColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
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
              element.getDescription(locale),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.5,
                  ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: element.getZodiacSigns(locale).map(
                (sign) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: elementColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sign,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: elementColor.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
