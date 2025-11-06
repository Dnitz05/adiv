import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../theme/tarot_theme.dart';
import '../utils/card_image_mapper.dart';

class ChatSpreadBubble extends StatelessWidget {
  const ChatSpreadBubble({
    super.key,
    required this.spread,
    this.animate = false,
  });

  final ChatSpreadData spread;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final bubble = Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              spread.spreadName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            if ((spread.spreadDescription ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                spread.spreadDescription!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF616161),
                ),
              ),
            ],
            const SizedBox(height: 12),
            _SpreadGrid(spread: spread),
          ],
        ),
      ),
    );

    if (animate) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: bubble,
      );
    }

    return bubble;
  }
}

class _SpreadGrid extends StatelessWidget {
  const _SpreadGrid({required this.spread});

  final ChatSpreadData spread;

  @override
  Widget build(BuildContext context) {
    final rows = spread.rows > 0 ? spread.rows : 1;
    final columns = spread.columns > 0 ? spread.columns : 1;

    final grid = List.generate(
      rows,
      (_) => List<ChatSpreadCardData?>.filled(columns, null),
    );

    for (final card in spread.cards) {
      final rowIndex = _resolveRow(card, rows, columns);
      final columnIndex = _resolveColumn(card, rows, columns);
      grid[rowIndex][columnIndex] = card;
    }

    final availableWidth = MediaQuery.of(context).size.width * 0.72;
    final cardWidth = ((availableWidth - (columns - 1) * 12) / columns).clamp(80.0, 140.0);

    final children = <Widget>[];
    for (var row = 0; row < rows; row++) {
      final slots = grid[row];
      children.add(
        Padding(
          padding: EdgeInsets.only(top: row == 0 ? 0 : 12),
          child: Row(
            mainAxisAlignment:
                columns == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
            children: List.generate(columns, (column) {
              final card = slots[column];
              if (card == null) {
                return SizedBox(
                  width: cardWidth,
                  height: cardWidth * 1.6,
                );
              }
              return _SpreadCard(card: card, width: cardWidth);
            }),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  int _resolveRow(ChatSpreadCardData card, int rows, int columns) {
    if (card.row >= 0 && card.row < rows) {
      return card.row;
    }
    final computed = ((card.position - 1) / columns).floor();
    return computed.clamp(0, rows - 1);
  }

  int _resolveColumn(ChatSpreadCardData card, int rows, int columns) {
    if (card.column >= 0 && card.column < columns) {
      return card.column;
    }
    final computed = (card.position - 1) % columns;
    return computed.clamp(0, columns - 1);
  }
}

class _SpreadCard extends StatelessWidget {
  const _SpreadCard({
    required this.card,
    required this.width,
  });

  final ChatSpreadCardData card;
  final double width;

  @override
  Widget build(BuildContext context) {
    final imagePath = (card.image != null && card.image!.isNotEmpty)
        ? card.image!
        : CardImageMapper.getCardImagePath(card.name, card.suit);
    final cardLabel = card.meaning ??
        card.meaningShort ??
        'Position ${card.position}';

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 0.66,
            child: _buildImage(imagePath),
          ),
          const SizedBox(height: 6),
          Text(
            card.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (cardLabel.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              cardLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF616161),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    final borderRadius = BorderRadius.circular(12);
    if (imagePath != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.rotate(
              angle: card.upright ? 0 : math.pi,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  card.upright ? 'Upright' : 'Reversed',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.7),
            TarotTheme.cosmicAccent.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Text(
        card.name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
