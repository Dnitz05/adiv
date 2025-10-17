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
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Always 3 columns
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: TarotSpreads.all.length,
          itemBuilder: (context, index) {
            final spread = TarotSpreads.all[index];
            return _SpreadCard(
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

/// Individual spread card in the gallery
class _SpreadCard extends StatelessWidget {
  final TarotSpread spread;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpreadCard({
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
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon area
              Expanded(
                flex: 3,
                child: _getSpreadIcon(spread),
              ),
              const SizedBox(height: 10),
              // Name
              Text(
                spread.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TarotTheme.moonlight,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Card count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TarotTheme.cosmicAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${spread.cardCount} ${spread.cardCount == 1 ? "carta" : "cartas"}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: TarotTheme.cosmicAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get the icon widget for a spread (SVG or fallback icon)
  Widget _getSpreadIcon(TarotSpread spread) {
    final svgPath = _getSpreadSvgPath(spread.id);

    if (svgPath != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          svgPath,
          fit: BoxFit.contain,
        ),
      );
    } else {
      // Fallback icon
      return Icon(
        _getPlaceholderIcon(spread.id),
        size: 56,
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
