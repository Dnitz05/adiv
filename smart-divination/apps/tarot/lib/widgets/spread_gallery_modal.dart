import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/tarot_spread.dart';
import '../theme/tarot_theme.dart';

/// Full page that displays all available spreads in a visual gallery grid
class SpreadGalleryPage extends StatelessWidget {
  final TarotSpread selectedSpread;
  final ValueChanged<TarotSpread> onSpreadSelected;

  const SpreadGalleryPage({
    super.key,
    required this.selectedSpread,
    required this.onSpreadSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final locale = localisation.localeName;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grid_view,
              color: TarotTheme.cosmicAccent,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              _headlineForLocale(locale),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TarotTheme.moonlight,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: TarotTheme.deepNight,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TarotTheme.deepNight,
              TarotTheme.midnightBlue,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: TarotSpreads.all.length,
          itemBuilder: (context, index) {
            final spread = TarotSpreads.all[index];
            return _SpreadRow(
              spread: spread,
              isSelected: spread.id == selectedSpread.id,
              onTap: () {
                onSpreadSelected(spread);
                Navigator.pop(context);
              },
              locale: locale,
            );
          },
        ),
      ),
    );
  }

  String _headlineForLocale(String locale) {
    final language = locale.split(RegExp('[_-]')).first.toLowerCase();
    switch (language) {
      case 'ca':
        return 'Selecciona la teva tirada';
      case 'en':
        return 'Select your spread';
      default:
        return 'Selecciona tu tirada';
    }
  }
}

/// Individual spread row in the gallery
class _SpreadRow extends StatelessWidget {
  final TarotSpread spread;
  final bool isSelected;
  final VoidCallback onTap;
  final String locale;

  const _SpreadRow({
    required this.spread,
    required this.isSelected,
    required this.onTap,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TarotTheme.cosmicBlue.withValues(alpha: isSelected ? 0.3 : 0.15),
              TarotTheme.twilightPurple.withValues(alpha: isSelected ? 0.3 : 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? TarotTheme.cosmicAccent
                : TarotTheme.stardust.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TarotTheme.cosmicAccent.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Icon, Title and card count
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: TarotTheme.deepNight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: _getSpreadIcon(spread),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and card count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spread.localizedName(locale),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: TarotTheme.moonlight,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: TarotTheme.cosmicAccent.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _cardCountLabel(spread.cardCount, locale),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: TarotTheme.cosmicAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description below
              Text(
                _getSpreadUseCase(spread, locale),
                style: TextStyle(
                  fontSize: 14,
                  color: TarotTheme.stardust.withValues(alpha: 0.95),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _cardCountLabel(int count, String locale) {
    final language = locale.split(RegExp('[_-]')).first.toLowerCase();
    final isPlural = count != 1;
    switch (language) {
      case 'ca':
        return "$count ${isPlural ? 'cartes' : 'carta'}";
      case 'es':
        return "$count ${isPlural ? 'cartas' : 'carta'}";
      default:
        return "$count ${isPlural ? 'cards' : 'card'}";
    }
  }

  /// Get use case description for each spread
  String _getSpreadUseCase(TarotSpread spread, String locale) {
    final language = locale.split(RegExp('[_-]')).first.toLowerCase();
    if (language == 'es') {
      switch (spread.id) {
        case 'single':
          return 'Tu guía diaria esencial. Corta el ruido y enfoca tu atención en un mensaje claro para las próximas 24 horas. Perfecta cuando buscas orientación rápida sin complejidades o necesitas una respuesta directa a una pregunta concreta.';
        case 'two_card':
          return 'La tirada de decisiones. Dos cartas revelan las consecuencias de elegir entre dos caminos. Úsala cuando te enfrentas a una elección binaria: aceptar o rechazar, continuar o parar, actuar o esperar. Excelente para comparar opciones y ver claramente qué te espera en cada dirección.';
        case 'three_card':
          return 'La más versátil del tarot. Revela pasado-presente-futuro o responde preguntas directas. Su simplicidad oculta una profundidad sorprendente para analizar cualquier situación. También puede interpretarse como situación-acción-resultado o mente-cuerpo-espíritu según tu necesidad.';
        case 'five_card_cross':
          return 'El equilibrio perfecto entre simplicidad y profundidad. Esta cruz de cinco cartas mapea pasado, presente y futuro en línea horizontal, con una carta debajo revelando lo que te retiene y otra arriba mostrando el consejo para avanzar. Más completa que tres cartas pero más rápida que el Celtic Cross.';
        case 'relationship':
          return 'Examina brutalmente tu relación. Descubre tensiones no habladas, patrones insanos y puntos ciegos. Siete cartas revelan tu posición, la de tu pareja, fortalezas compartidas, desafíos ocultos y necesidades de ambos. Ideal para parejas atascadas que necesitan claridad sobre la verdadera dinámica.';
        case 'pyramid':
          return 'La tirada holística de seis cartas. Explora tu objetivo en la cima, descendiendo a mente y corazón en el medio, finalizando con acción, recursos y fundamento en la base. Perfecta cuando necesitas entender todos los aspectos de una meta: desde la aspiración espiritual hasta los pasos prácticos.';
        case 'horseshoe':
          return 'El equilibrio perfecto: profunda pero manejable. Siete cartas dispuestas en herradura revelan pasado, presente, influencias ocultas, obstáculos, actitudes externas, consejos y resultado probable. Proporciona una visión completa sin abrumar. La preferida de lectores profesionales por su versatilidad.';
        case 'celtic_cross':
          return 'La tirada maestra del tarot. Diez cartas que desglosan paso a paso cualquier situación compleja: presente, desafío, pasado distante y reciente, meta, futuro cercano, tu actitud, influencias externas, esperanzas/miedos y resultado final. Flexible: úsala con pregunta específica o para panorama general. Requiere práctica.';
        case 'star':
          return 'Explora tu pregunta en múltiples dimensiones. Siete cartas en forma de estrella revelan aspectos espirituales (arriba), abundancia, amor, creatividad, sabiduría (los puntos) y tu esencia central. Perfecta para autodescubrimiento profundo y entender cómo diferentes áreas de tu vida se conectan e influencian mutuamente.';
        case 'astrological':
          return 'La tirada de las 12 casas astrológicas. Un círculo completo de doce cartas, cada una representando un área vital según la astrología: identidad, recursos, comunicación, hogar, creatividad, salud, relaciones, transformación, sabiduría, propósito, comunidad y espiritualidad. Ideal para una fotografía completa de tu vida actual.';
        case 'year_ahead':
          return 'Tu mapa anual mes a mes. Doce cartas representan cada mes del año siguiendo el ciclo zodiacal. Perfecta para planificación estratégica de Año Nuevo o cumpleaños, te ayuda a anticipar energías, prepararte para desafíos y aprovechar oportunidades. Revela el ritmo natural de tu próximo ciclo solar.';
      }
    }
    return spread.localizedDescription(locale);
  }

  /// Get the icon widget for a spread (SVG or fallback icon)
  Widget _getSpreadIcon(TarotSpread spread) {
    final svgPath = _getSpreadSvgPath(spread.id);

    if (svgPath != null) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: SvgPicture.asset(
          svgPath,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
      );
    } else {
      // Fallback icon
      return Icon(
        _getPlaceholderIcon(spread.id),
        size: 40,
        color: TarotTheme.cosmicAccent.withValues(alpha: 0.7),
      );
    }
  }

  /// Map spread ID to SVG asset path
  /// Temporarily using existing icons for all spreads
  String? _getSpreadSvgPath(String spreadId) {
    switch (spreadId) {
      case 'three_card':
        return 'assets/spread-buttons/three-card-spread.svg';
      case 'celtic_cross':
        return 'assets/spread-buttons/celtic-cross-spread.svg';
      // Temporarily reuse icons for other spreads
      case 'single':
        return 'assets/spread-buttons/three-card-spread.svg'; // Reutilizar
      case 'two_card':
        return 'assets/spread-buttons/three-card-spread.svg'; // Reutilizar
      case 'five_card_cross':
        return 'assets/spread-buttons/simple-cross-spread.svg'; // Reutilizar
      case 'relationship':
        return 'assets/spread-buttons/simple-cross-spread.svg'; // Reutilizar
      case 'pyramid':
        return 'assets/spread-buttons/three-card-spread.svg'; // Reutilizar
      case 'horseshoe':
        return 'assets/spread-buttons/simple-cross-spread.svg'; // Reutilizar
      case 'star':
        return 'assets/spread-buttons/celtic-cross-spread.svg'; // Reutilizar
      case 'astrological':
        return 'assets/spread-buttons/celtic-cross-spread.svg'; // Reutilizar
      case 'year_ahead':
        return 'assets/spread-buttons/celtic-cross-spread.svg'; // Reutilizar
      default:
        return null;
    }
  }

  /// Fallback Material icons for spreads without SVG
  IconData _getPlaceholderIcon(String spreadId) {
    switch (spreadId) {
      case 'single':
        return Icons.rectangle_outlined;
      case 'two_card':
        return Icons.compare_arrows;
      case 'five_card_cross':
        return Icons.add;
      case 'relationship':
        return Icons.favorite_border;
      case 'pyramid':
        return Icons.change_history;
      case 'horseshoe':
        return Icons.u_turn_right;
      case 'star':
        return Icons.star_border;
      case 'astrological':
        return Icons.album;
      case 'year_ahead':
        return Icons.calendar_month;
      default:
        return Icons.grid_on;
    }
  }
}
