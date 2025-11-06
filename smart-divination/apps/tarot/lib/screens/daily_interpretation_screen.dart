import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';
import '../models/tarot_card.dart';
import '../api/interpretation_api.dart';
import '../api/draw_cards_api.dart';

/// Screen that shows daily draw interpretation in 4 areas:
/// - General
/// - Love
/// - Work/Money
/// - Health
class DailyInterpretationScreen extends StatefulWidget {
  const DailyInterpretationScreen({
    super.key,
    required this.cards,
    required this.draw,
    required this.sessionId,
  });

  final List<TarotCard> cards;
  final CardsDrawResponse draw;
  final String sessionId;

  @override
  State<DailyInterpretationScreen> createState() =>
      _DailyInterpretationScreenState();
}

class _DailyInterpretationScreenState
    extends State<DailyInterpretationScreen> {
  bool _loading = true;
  String? _error;

  InterpretationResult? _generalInterpretation;
  InterpretationResult? _loveInterpretation;
  InterpretationResult? _workInterpretation;
  InterpretationResult? _healthInterpretation;

  @override
  void initState() {
    super.initState();
    _loadAllInterpretations();
  }

  Future<void> _loadAllInterpretations() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final locale = CommonStrings.of(context).localeName;

      // Load all 4 interpretations in parallel
      final results = await Future.wait([
        submitInterpretation(
          sessionId: widget.sessionId,
          draw: widget.draw,
          question: _getGeneralQuestion(locale),
          locale: locale,
        ),
        submitInterpretation(
          sessionId: widget.sessionId,
          draw: widget.draw,
          question: _getLoveQuestion(locale),
          locale: locale,
        ),
        submitInterpretation(
          sessionId: widget.sessionId,
          draw: widget.draw,
          question: _getWorkQuestion(locale),
          locale: locale,
        ),
        submitInterpretation(
          sessionId: widget.sessionId,
          draw: widget.draw,
          question: _getHealthQuestion(locale),
          locale: locale,
        ),
      ]);

      if (!mounted) return;

      setState(() {
        _generalInterpretation = results[0];
        _loveInterpretation = results[1];
        _workInterpretation = results[2];
        _healthInterpretation = results[3];
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

  String _getGeneralQuestion(String locale) {
    switch (locale) {
      case 'ca':
        return 'Quina és la visió general del dia d\'avui?';
      case 'es':
        return '¿Cuál es la visión general del día de hoy?';
      default:
        return 'What is the general outlook for today?';
    }
  }

  String _getLoveQuestion(String locale) {
    switch (locale) {
      case 'ca':
        return 'Què em diuen les cartes sobre l\'amor avui?';
      case 'es':
        return '¿Qué me dicen las cartas sobre el amor hoy?';
      default:
        return 'What do the cards say about love today?';
    }
  }

  String _getWorkQuestion(String locale) {
    switch (locale) {
      case 'ca':
        return 'Què em diuen les cartes sobre el treball i els diners avui?';
      case 'es':
        return '¿Qué me dicen las cartas sobre el trabajo y el dinero hoy?';
      default:
        return 'What do the cards say about work and money today?';
    }
  }

  String _getHealthQuestion(String locale) {
    switch (locale) {
      case 'ca':
        return 'Què em diuen les cartes sobre la salut avui?';
      case 'es':
        return '¿Qué me dicen las cartas sobre la salud hoy?';
      default:
        return 'What do the cards say about health today?';
    }
  }

  String _getGeneralTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Visió General';
      case 'es':
        return 'Visión General';
      default:
        return 'General Outlook';
    }
  }

  String _getLoveTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Amor';
      case 'es':
        return 'Amor';
      default:
        return 'Love';
    }
  }

  String _getWorkTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Treball i Diners';
      case 'es':
        return 'Trabajo y Dinero';
      default:
        return 'Work & Money';
    }
  }

  String _getHealthTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Salut';
      case 'es':
        return 'Salud';
      default:
        return 'Health';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final locale = localisation.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale == 'ca'
              ? 'Interpretació del Dia'
              : locale == 'es'
                  ? 'Interpretación del Día'
                  : 'Daily Interpretation',
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: TarotTheme.cosmicAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    locale == 'ca'
                        ? 'Preparant interpretacions...'
                        : locale == 'es'
                            ? 'Preparando interpretaciones...'
                            : 'Preparing interpretations...',
                    style: TextStyle(color: TarotTheme.stardust),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: TextStyle(color: TarotTheme.moonlight),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadAllInterpretations,
                          child: Text(
                            locale == 'ca'
                                ? 'Tornar a intentar'
                                : locale == 'es'
                                    ? 'Reintentar'
                                    : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInterpretationSection(
                        title: _getGeneralTitle(locale),
                        icon: Icons.auto_awesome,
                        interpretation: _generalInterpretation,
                        color: TarotTheme.cosmicBlue,
                      ),
                      const SizedBox(height: 20),
                      _buildInterpretationSection(
                        title: _getLoveTitle(locale),
                        icon: Icons.favorite,
                        interpretation: _loveInterpretation,
                        color: Colors.pink[300]!,
                      ),
                      const SizedBox(height: 20),
                      _buildInterpretationSection(
                        title: _getWorkTitle(locale),
                        icon: Icons.work,
                        interpretation: _workInterpretation,
                        color: Colors.amber[700]!,
                      ),
                      const SizedBox(height: 20),
                      _buildInterpretationSection(
                        title: _getHealthTitle(locale),
                        icon: Icons.favorite_border,
                        interpretation: _healthInterpretation,
                        color: Colors.green[400]!,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInterpretationSection({
    required String title,
    required IconData icon,
    required InterpretationResult? interpretation,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: TarotTheme.midnightBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (interpretation != null)
            Text(
              interpretation.interpretation,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black.withValues(alpha: 0.85),
              ),
            )
          else
            Text(
              'No interpretation available',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: TarotTheme.stardust,
              ),
            ),
        ],
      ),
    );
  }
}
