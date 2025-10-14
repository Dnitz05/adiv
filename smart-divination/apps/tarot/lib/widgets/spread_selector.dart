import 'package:flutter/material.dart';
import '../models/tarot_spread.dart';

class SpreadSelector extends StatelessWidget {
  final TarotSpread selectedSpread;
  final ValueChanged<TarotSpread> onSpreadChanged;

  const SpreadSelector({
    super.key,
    required this.selectedSpread,
    required this.onSpreadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TarotSpread>(
          value: selectedSpread,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: TarotSpreads.all.map((spread) {
            return DropdownMenuItem<TarotSpread>(
              value: spread,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    spread.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${spread.cardCount} cards - ${spread.description}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (spread) {
            if (spread != null) {
              onSpreadChanged(spread);
            }
          },
        ),
      ),
    );
  }
}
