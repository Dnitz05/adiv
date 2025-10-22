import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/tarot_spread.dart';
import '../theme/tarot_theme.dart';
import 'spread_layout.dart';

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
              TarotTheme.twilightPurple
                  .withValues(alpha: isSelected ? 0.3 : 0.15),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final double diagramHeight = screenHeight * 0.45;
              final double legendWidth =
                  math.max((constraints.maxWidth - 12) / 2, 140.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: diagramHeight,
                    child: SpreadLayout(
                      spread: spread,
                      cards: const [],
                      maxWidth: constraints.maxWidth,
                      maxHeight: diagramHeight,
                      revealedCardCount: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      for (int i = 0; i < spread.positions.length; i++)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: legendWidth),
                          child: _PositionLegend(
                            number: i + 1,
                            label: spread.positions[i].label,
                            description: spread.positions[i].description,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spread.localizedName(locale),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: TarotTheme.moonlight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              TarotTheme.cosmicAccent.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _cardCountLabel(spread.cardCount, locale),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TarotTheme.cosmicAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getSpreadUseCase(spread, locale),
                    style: const TextStyle(
                      fontSize: 14,
                      color: TarotTheme.stardust,
                      height: 1.55,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PositionLegend extends StatelessWidget {
  const _PositionLegend({
    required this.number,
    required this.label,
    required this.description,
  });

  final int number;
  final String? label;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TarotTheme.midnightBlueTransparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TarotTheme.cosmicAccentSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label != null && label!.isNotEmpty ? '$number. $label' : '$number',
            style: const TextStyle(
              color: TarotTheme.moonlight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: const TextStyle(
                color: TarotTheme.stardust,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
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
        return 'Tu guÃƒÂ­a diaria esencial. Corta el ruido y enfoca tu atenciÃƒÂ³n en un mensaje claro para las prÃƒÂ³ximas 24 horas. Perfecta cuando buscas orientaciÃƒÂ³n rÃƒÂ¡pida sin complejidades o necesitas una respuesta directa a una pregunta concreta.';
      case 'two_card':
        return 'La tirada de decisiones. Dos cartas revelan las consecuencias de elegir entre dos caminos. ÃƒÅ¡sala cuando te enfrentas a una elecciÃƒÂ³n binaria: aceptar o rechazar, continuar o parar, actuar o esperar. Excelente para comparar opciones y ver claramente quÃƒÂ© te espera en cada direcciÃƒÂ³n.';
      case 'three_card':
        return 'La mÃƒÂ¡s versÃƒÂ¡til del tarot. Revela pasado-presente-futuro o responde preguntas directas. Su simplicidad oculta una profundidad sorprendente para analizar cualquier situaciÃƒÂ³n. TambiÃƒÂ©n puede interpretarse como situaciÃƒÂ³n-acciÃƒÂ³n-resultado o mente-cuerpo-espÃƒÂ­ritu segÃƒÂºn tu necesidad.';
      case 'five_card_cross':
        return 'El equilibrio perfecto entre simplicidad y profundidad. Esta cruz de cinco cartas mapea pasado, presente y futuro en lÃƒÂ­nea horizontal, con una carta debajo revelando lo que te retiene y otra arriba mostrando el consejo para avanzar. MÃƒÂ¡s completa que tres cartas pero mÃƒÂ¡s rÃƒÂ¡pida que el Celtic Cross.';
      case 'relationship':
        return 'Examina brutalmente tu relaciÃƒÂ³n. Descubre tensiones no habladas, patrones insanos y puntos ciegos. Siete cartas revelan tu posiciÃƒÂ³n, la de tu pareja, fortalezas compartidas, desafÃƒÂ­os ocultos y necesidades de ambos. Ideal para parejas atascadas que necesitan claridad sobre la verdadera dinÃƒÂ¡mica.';
      case 'pyramid':
        return 'La tirada holÃƒÂ­stica de seis cartas. Explora tu objetivo en la cima, descendiendo a mente y corazÃƒÂ³n en el medio, finalizando con acciÃƒÂ³n, recursos y fundamento en la base. Perfecta cuando necesitas entender todos los aspectos de una meta: desde la aspiraciÃƒÂ³n espiritual hasta los pasos prÃƒÂ¡cticos.';
      case 'horseshoe':
        return 'El equilibrio perfecto: profunda pero manejable. Siete cartas dispuestas en herradura revelan pasado, presente, influencias ocultas, obstÃƒÂ¡culos, actitudes externas, consejos y resultado probable. Proporciona una visiÃƒÂ³n completa sin abrumar. La preferida de lectores profesionales por su versatilidad.';
      case 'celtic_cross':
        return 'La tirada maestra del tarot. Diez cartas que desglosan paso a paso cualquier situaciÃƒÂ³n compleja: presente, desafÃƒÂ­o, pasado distante y reciente, meta, futuro cercano, tu actitud, influencias externas, esperanzas/miedos y resultado final. Flexible: ÃƒÂºsala con pregunta especÃƒÂ­fica o para panorama general. Requiere prÃƒÂ¡ctica.';
      case 'star':
        return 'Explora tu pregunta en mÃƒÂºltiples dimensiones. Siete cartas en forma de estrella revelan aspectos espirituales (arriba), abundancia, amor, creatividad, sabidurÃƒÂ­a (los puntos) y tu esencia central. Perfecta para autodescubrimiento profundo y entender cÃƒÂ³mo diferentes ÃƒÂ¡reas de tu vida se conectan e influencian mutuamente.';
      case 'astrological':
        return 'La tirada de las 12 casas astrolÃƒÂ³gicas. Un cÃƒÂ­rculo completo de doce cartas, cada una representando un ÃƒÂ¡rea vital segÃƒÂºn la astrologÃƒÂ­a: identidad, recursos, comunicaciÃƒÂ³n, hogar, creatividad, salud, relaciones, transformaciÃƒÂ³n, sabidurÃƒÂ­a, propÃƒÂ³sito, comunidad y espiritualidad. Ideal para una fotografÃƒÂ­a completa de tu vida actual.';
      case 'year_ahead':
        return 'Tu mapa anual mes a mes. Doce cartas representan cada mes del aÃƒÂ±o siguiendo el ciclo zodiacal. Perfecta para planificaciÃƒÂ³n estratÃƒÂ©gica de AÃƒÂ±o Nuevo o cumpleaÃƒÂ±os, te ayuda a anticipar energÃƒÂ­as, prepararte para desafÃƒÂ­os y aprovechar oportunidades. Revela el ritmo natural de tu prÃƒÂ³ximo ciclo solar.';
    }
  }
  return spread.localizedDescription(locale);
}
