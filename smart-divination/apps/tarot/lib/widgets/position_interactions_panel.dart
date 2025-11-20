import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../theme/tarot_theme.dart';

/// FASE 3: Widget to display position interactions (card relationships)
/// Shows educational content about how positions relate to each other in a spread
class PositionInteractionsPanel extends StatefulWidget {
  const PositionInteractionsPanel({
    super.key,
    required this.interactions,
    this.title = 'Card Relationships',
    this.locale = 'en',
  });

  final List<PositionInteraction> interactions;
  final String title;
  final String locale;

  @override
  State<PositionInteractionsPanel> createState() => _PositionInteractionsPanelState();
}

class _PositionInteractionsPanelState extends State<PositionInteractionsPanel> {
  final Set<int> _expandedIndices = {};

  String _getReadingGuidanceLabel() {
    switch (widget.locale) {
      case 'ca':
        return 'Guia de Lectura';
      case 'es':
        return 'Guía de Lectura';
      default:
        return 'Reading Guidance';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.interactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: TarotTheme.skyBlueLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TarotTheme.brightBlue20,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.skyBlueShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TarotTheme.brightBlue10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_tree_outlined,
                    color: TarotTheme.brightBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: TarotTheme.deepNavy,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: TarotTheme.brightBlue10,
          ),

          // Interactions list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: widget.interactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final interaction = widget.interactions[index];
              final isExpanded = _expandedIndices.contains(index);

              return _buildInteractionCard(
                interaction,
                index,
                isExpanded,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionCard(
    PositionInteraction interaction,
    int index,
    bool isExpanded,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.brightBlue10,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedIndices.remove(index);
                } else {
                  _expandedIndices.add(index);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Positions involved
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (int i = 0; i < interaction.positions.length; i++) ...[
                              _buildPositionChip(interaction.positions[i]),
                              if (i < interaction.positions.length - 1)
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: TarotTheme.slateBlue,
                                ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: TarotTheme.brightBlue,
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description (FASE 3: now supports multilingual)
                  Text(
                    interaction.getDescription(widget.locale),
                    style: const TextStyle(
                      fontSize: 14,
                      color: TarotTheme.deepNavy,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content (AI guidance)
          if (isExpanded) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TarotTheme.skyBlueSoft,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: TarotTheme.brightBlue10,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: TarotTheme.warmGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getReadingGuidanceLabel(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: TarotTheme.slateBlue,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    interaction.aiGuidance,
                    style: const TextStyle(
                      fontSize: 13,
                      color: TarotTheme.softBlueGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionChip(String positionCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TarotTheme.brightBlue10,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: TarotTheme.brightBlue20,
          width: 0.5,
        ),
      ),
      child: Text(
        positionCode,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: TarotTheme.brightBlue,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
