import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';
import '../widgets/lunar_ai_advisor.dart';

class LunarAdvisorScreen extends StatelessWidget {
  final CommonStrings strings;
  final String? userId;

  const LunarAdvisorScreen({
    super.key,
    required this.strings,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: TarotTheme.lunarLavenderLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TarotTheme.lunarLavenderLight,
              TarotTheme.lunarLavenderSoft,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LunarAiAdvisor(
              strings: strings,
              userId: userId,
              locale: strings.localeName,
              onShareAdvice: (advice) {
                // Could navigate to chat or show dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_getSharedMessage()),
                    backgroundColor: TarotTheme.lunarLavenderLight,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (strings.localeName) {
      case 'es':
        return 'Consulta la Luna';
      case 'ca':
        return 'Pregunta a la Lluna';
      default:
        return 'Ask the Moon';
    }
  }

  String _getSharedMessage() {
    switch (strings.localeName) {
      case 'es':
        return 'Consejo lunar compartido';
      case 'ca':
        return 'Consell lunar compartit';
      default:
        return 'Lunar advice shared';
    }
  }
}
