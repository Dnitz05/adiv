import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';
import '../api/spread_recommendation_api.dart';
import '../models/tarot_spread.dart';

/// Screen for AI-powered spread selection
/// Users describe their situation and get a recommended spread
class SmartSelectionScreen extends StatefulWidget {
  const SmartSelectionScreen({super.key});

  @override
  State<SmartSelectionScreen> createState() => _SmartSelectionScreenState();
}

class _SmartSelectionScreenState extends State<SmartSelectionScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool _loading = false;
  SpreadRecommendation? _recommendation;
  String? _error;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendation() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      setState(() {
        _error = _getEmptyQuestionError();
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _recommendation = null;
    });

    try {
      final locale = CommonStrings.of(context).localeName;
      final result = await recommendSpread(
        question: question,
        locale: locale,
      );

      if (!mounted) return;

      setState(() {
        _recommendation = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _getEmptyQuestionError() {
    final locale = CommonStrings.of(context).localeName;
    switch (locale) {
      case 'ca':
        return 'Si us plau, descriu la teva situació';
      case 'es':
        return 'Por favor, describe tu situación';
      default:
        return 'Please describe your situation';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final locale = localisation.localeName;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(locale)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _recommendation != null
          ? _buildRecommendationView(locale, theme)
          : _buildInputView(locale, theme),
    );
  }

  Widget _buildInputView(String locale, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AI Icon with gradient
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    TarotTheme.cosmicBlue,
                    TarotTheme.cosmicAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TarotTheme.cosmicBlue.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            _getInputTitle(locale),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: TarotTheme.midnightBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            _getInputSubtitle(locale),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Text input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _questionController,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: _getPlaceholder(locale),
                hintStyle: TextStyle(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                counterStyle: TextStyle(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              style: TextStyle(
                fontSize: 15,
                color: TarotTheme.midnightBlue,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Error message
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Submit button
          FilledButton(
            onPressed: _loading ? null : _getRecommendation,
            style: FilledButton.styleFrom(
              backgroundColor: TarotTheme.cosmicBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _getAnalyzeButton(locale),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 24),

          // Examples
          Text(
            _getExamplesTitle(locale),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          ..._getExamples(locale).map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _questionController.text = example;
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TarotTheme.cosmicAccent.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: TarotTheme.cosmicAccent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            example,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationView(String locale, ThemeData theme) {
    final rec = _recommendation!;
    final spread = TarotSpreads.getById(rec.spreadId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success icon
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[50],
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            _getRecommendationTitle(locale),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: TarotTheme.midnightBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Spread card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  TarotTheme.cosmicBlue,
                  TarotTheme.cosmicAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: TarotTheme.cosmicBlue.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  spread?.name ?? rec.spreadId,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${spread?.cardCount ?? 0} ${_getCardsLabel(locale)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reasoning
          Text(
            _getWhyTitle(locale),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: TarotTheme.midnightBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            rec.reasoning,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 32),

          // Actions
          FilledButton(
            onPressed: () {
              // TODO: Start spread with this configuration
              Navigator.of(context).pop();
              debugPrint('Start spread: ${rec.spreadId}');
            },
            style: FilledButton.styleFrom(
              backgroundColor: TarotTheme.cosmicBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _getStartButton(locale),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _recommendation = null;
                _error = null;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: TarotTheme.cosmicBlue),
            ),
            child: Text(
              _getTryAnotherButton(locale),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TarotTheme.cosmicBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Localized strings
  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Selecció Intel·ligent';
      case 'es':
        return 'Selección Inteligente';
      default:
        return 'Smart Selection';
    }
  }

  String _getInputTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Descriu la teva situació';
      case 'es':
        return 'Describe tu situación';
      default:
        return 'Describe your situation';
    }
  }

  String _getInputSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'L\'AI analitzarà el teu context i et recomana la millor tirada';
      case 'es':
        return 'La IA analizará tu contexto y te recomienda la mejor tirada';
      default:
        return 'AI will analyze your context and recommend the best spread';
    }
  }

  String _getPlaceholder(String locale) {
    switch (locale) {
      case 'ca':
        return 'Ex: "Estic pensant en canviar de feina però tinc por de no trobar res millor..."';
      case 'es':
        return 'Ej: "Estoy pensando en cambiar de trabajo pero tengo miedo de no encontrar nada mejor..."';
      default:
        return 'Ex: "I\'m thinking about changing jobs but I\'m afraid I won\'t find anything better..."';
    }
  }

  String _getAnalyzeButton(String locale) {
    switch (locale) {
      case 'ca':
        return 'Analitzar i Recomanar';
      case 'es':
        return 'Analizar y Recomendar';
      default:
        return 'Analyze & Recommend';
    }
  }

  String _getExamplesTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Exemples:';
      case 'es':
        return 'Ejemplos:';
      default:
        return 'Examples:';
    }
  }

  List<String> _getExamples(String locale) {
    switch (locale) {
      case 'ca':
        return [
          'M\'agradaria saber si la meva relació té futur',
          'Tinc una decisió important sobre la meva carrera',
          'Estic confós sobre què fer amb les meves finances',
        ];
      case 'es':
        return [
          'Me gustaría saber si mi relación tiene futuro',
          'Tengo una decisión importante sobre mi carrera',
          'Estoy confundido sobre qué hacer con mis finanzas',
        ];
      default:
        return [
          'I\'d like to know if my relationship has a future',
          'I have an important decision about my career',
          'I\'m confused about what to do with my finances',
        ];
    }
  }

  String _getRecommendationTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Recomanació perfecta per tu';
      case 'es':
        return 'Recomendación perfecta para ti';
      default:
        return 'Perfect recommendation for you';
    }
  }

  String _getWhyTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Per què aquesta tirada?';
      case 'es':
        return '¿Por qué esta tirada?';
      default:
        return 'Why this spread?';
    }
  }

  String _getCardsLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'cartes';
      case 'es':
        return 'cartas';
      default:
        return 'cards';
    }
  }

  String _getStartButton(String locale) {
    switch (locale) {
      case 'ca':
        return 'Començar Tirada';
      case 'es':
        return 'Comenzar Tirada';
      default:
        return 'Start Spread';
    }
  }

  String _getTryAnotherButton(String locale) {
    switch (locale) {
      case 'ca':
        return 'Provar una altra';
      case 'es':
        return 'Probar otra';
      default:
        return 'Try another';
    }
  }
}
