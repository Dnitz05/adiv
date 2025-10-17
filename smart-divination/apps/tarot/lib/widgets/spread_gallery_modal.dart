import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

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
              'Selecciona tu Tirada',
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
            );
          },
        ),
      ),
    );
  }
}

/// Individual spread row in the gallery
class _SpreadRow extends StatelessWidget {
  final TarotSpread spread;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpreadRow({
    required this.spread,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TarotTheme.cosmicBlue.withOpacity(isSelected ? 0.3 : 0.15),
              TarotTheme.twilightPurple.withOpacity(isSelected ? 0.3 : 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? TarotTheme.cosmicAccent
                : TarotTheme.stardust.withOpacity(0.3),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TarotTheme.cosmicAccent.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: TarotTheme.deepNight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TarotTheme.cosmicAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: _getSpreadIcon(spread),
                ),
              ),
              const SizedBox(width: 16),
              // Middle: Title and card count
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spread.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TarotTheme.moonlight,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: TarotTheme.cosmicAccent.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${spread.cardCount} ${spread.cardCount == 1 ? "carta" : "cartas"}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: TarotTheme.cosmicAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right: Description
              Expanded(
                flex: 3,
                child: Text(
                  _getSpreadUseCase(spread.id),
                  style: TextStyle(
                    fontSize: 13,
                    color: TarotTheme.stardust.withOpacity(0.95),
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get use case description for each spread
  String _getSpreadUseCase(String spreadId) {
    switch (spreadId) {
      case 'single':
        return 'Tu guía diaria esencial. Corta el ruido y enfoca tu atención en un mensaje claro para las próximas 24 horas. Perfecta cuando buscas orientación rápida sin complejidades.';
      case 'three_card':
        return 'La más versátil del tarot. Revela pasado-presente-futuro o responde preguntas directas. Su simplicidad oculta una profundidad sorprendente para analizar cualquier situación.';
      case 'relationship':
        return 'Examina brutalmente tu relación. Descubre tensiones no habladas, patrones insanos y puntos ciegos. Ideal para parejas atascadas que necesitan claridad sobre la verdadera dinámica.';
      case 'pyramid':
        return 'La tirada de lujo. 21 cartas que describen detalles específicos, revelan intenciones ocultas y presentan opciones. También funciona como revisión periódica de tu camino vital.';
      case 'horseshoe':
        return 'El equilibrio perfecto: profunda pero manejable. Siete cartas revelan pasado, presente, influencias ocultas, obstáculos, actitudes externas, consejos y resultado probable.';
      case 'celtic_cross':
        return 'La tirada maestra. Diez cartas que desglosan paso a paso cualquier situación compleja. Flexible: úsala con pregunta específica o para panorama general. Requiere práctica.';
      case 'star':
        return 'Explora tu pregunta en múltiples dimensiones. Siete cartas en forma de estrella revelan aspectos espirituales, influencias externas, sentimientos internos y esperanzas futuras.';
      case 'year_ahead':
        return 'Tu mapa anual. Doce cartas representan cada mes siguiendo el ciclo zodiacal. Perfecta para planificación estratégica y entender las energías que te esperan.';
      default:
        return spread.description;
    }
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
        color: TarotTheme.cosmicAccent.withOpacity(0.7),
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
      case 'relationship':
        return 'assets/spread-buttons/simple-cross-spread.svg'; // Reutilizar
      case 'pyramid':
        return 'assets/spread-buttons/three-card-spread.svg'; // Reutilizar
      case 'horseshoe':
        return 'assets/spread-buttons/simple-cross-spread.svg'; // Reutilizar
      case 'star':
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
      case 'relationship':
        return Icons.favorite_border;
      case 'pyramid':
        return Icons.change_history;
      case 'horseshoe':
        return Icons.u_turn_right;
      case 'star':
        return Icons.star_border;
      case 'year_ahead':
        return Icons.calendar_month;
      default:
        return Icons.grid_on;
    }
  }
}
