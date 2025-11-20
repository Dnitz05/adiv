import 'package:flutter/material.dart';
import '../theme/tarot_theme.dart';
import '../models/chat_message.dart';
import 'position_interactions_panel.dart';

/// FASE 3: Comprehensive educational content panel for tarot spreads
/// Displays purpose, when to use/avoid, interpretation method, and position interactions
class SpreadEducationalPanel extends StatefulWidget {
  const SpreadEducationalPanel({
    super.key,
    required this.educational,
    this.locale = 'en',
    this.showPositionInteractions = true,
  });

  final SpreadEducational educational;
  final String locale;
  final bool showPositionInteractions;

  @override
  State<SpreadEducationalPanel> createState() => _SpreadEducationalPanelState();
}

class _SpreadEducationalPanelState extends State<SpreadEducationalPanel> {
  final Set<String> _expandedSections = {};

  String _getLocalizedText(Map<String, String>? map) {
    if (map == null) return '';
    return map[widget.locale] ?? map['en'] ?? '';
  }

  String _getSectionLabel(String key) {
    switch (key) {
      case 'purpose':
        return {
          'en': 'Purpose of this Spread',
          'es': 'Propósito de esta Tirada',
          'ca': 'Propòsit d\'aquesta Tirada',
        }[widget.locale] ?? 'Purpose of this Spread';
      case 'whenToUse':
        return {
          'en': 'When to Use',
          'es': 'Cuándo Usar',
          'ca': 'Quan Utilitzar',
        }[widget.locale] ?? 'When to Use';
      case 'whenToAvoid':
        return {
          'en': 'When to Avoid',
          'es': 'Cuándo Evitar',
          'ca': 'Quan Evitar',
        }[widget.locale] ?? 'When to Avoid';
      case 'interpretationMethod':
        return {
          'en': 'How to Read',
          'es': 'Cómo Leer',
          'ca': 'Com Llegir',
        }[widget.locale] ?? 'How to Read';
      case 'traditionalOrigin':
        return {
          'en': 'History & Tradition',
          'es': 'Historia y Tradición',
          'ca': 'Història i Tradició',
        }[widget.locale] ?? 'History & Tradition';
      default:
        return key;
    }
  }

  IconData _getSectionIcon(String key) {
    switch (key) {
      case 'purpose':
        return Icons.center_focus_strong_outlined;
      case 'whenToUse':
        return Icons.check_circle_outline;
      case 'whenToAvoid':
        return Icons.warning_amber_outlined;
      case 'interpretationMethod':
        return Icons.menu_book_outlined;
      case 'traditionalOrigin':
        return Icons.history_edu;
      default:
        return Icons.info_outline;
    }
  }

  Color _getSectionColor(String key) {
    switch (key) {
      case 'purpose':
        return TarotTheme.brightBlue;
      case 'whenToUse':
        return const Color(0xFF10B981); // Success green
      case 'whenToAvoid':
        return const Color(0xFFEF4444); // Warning red
      case 'interpretationMethod':
        return TarotTheme.warmGold;
      case 'traditionalOrigin':
        return const Color(0xFF8B5CF6); // Purple for history
      default:
        return TarotTheme.slateBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TarotTheme.brightBlue.withOpacity(0.1),
                  TarotTheme.skyBlueSoft,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TarotTheme.brightBlue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: TarotTheme.brightBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        {
                          'en': 'Learning Guide',
                          'es': 'Guía de Aprendizaje',
                          'ca': 'Guia d\'Aprenentatge',
                        }[widget.locale] ?? 'Learning Guide',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: TarotTheme.deepNavy,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        {
                          'en': 'Deepen your understanding',
                          'es': 'Profundiza tu comprensión',
                          'ca': 'Aprofundeix la teva comprensió',
                        }[widget.locale] ?? 'Deepen your understanding',
                        style: TextStyle(
                          fontSize: 13,
                          color: TarotTheme.slateBlue.withOpacity(0.8),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content sections
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Purpose
                _buildSection(
                  key: 'purpose',
                  content: _getLocalizedText(widget.educational.purpose),
                ),

                const SizedBox(height: 12),

                // When to Use
                _buildSection(
                  key: 'whenToUse',
                  content: _getLocalizedText(widget.educational.whenToUse),
                ),

                const SizedBox(height: 12),

                // When to Avoid
                _buildSection(
                  key: 'whenToAvoid',
                  content: _getLocalizedText(widget.educational.whenToAvoid),
                ),

                const SizedBox(height: 12),

                // Interpretation Method
                _buildSection(
                  key: 'interpretationMethod',
                  content: _getLocalizedText(widget.educational.interpretationMethod),
                ),

                // Traditional Origin (if available)
                if (widget.educational.traditionalOrigin != null) ...[
                  const SizedBox(height: 12),
                  _buildSection(
                    key: 'traditionalOrigin',
                    content: _getLocalizedText(widget.educational.traditionalOrigin),
                  ),
                ],
              ],
            ),
          ),

          // Position Interactions
          if (widget.showPositionInteractions &&
              widget.educational.positionInteractions.isNotEmpty) ...[
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: TarotTheme.brightBlue10,
            ),
            const SizedBox(height: 8),
            PositionInteractionsPanel(
              interactions: widget.educational.positionInteractions,
              locale: widget.locale,
              title: {
                'en': 'Card Relationships',
                'es': 'Relaciones entre Cartas',
                'ca': 'Relacions entre Cartes',
              }[widget.locale] ?? 'Card Relationships',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String key,
    required String content,
  }) {
    if (content.isEmpty) return const SizedBox.shrink();

    final isExpanded = _expandedSections.contains(key);
    final color = _getSectionColor(key);
    final icon = _getSectionIcon(key);
    final label = _getSectionLabel(key);

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedSections.remove(key);
                } else {
                  _expandedSections.add(key);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: color,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: color.withOpacity(0.1),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: TarotTheme.deepNavy,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
