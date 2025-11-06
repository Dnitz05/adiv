import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../widgets/learn_panel.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({
    super.key,
    required this.strings,
    required this.onNavigateToCards,
    required this.onNavigateToKnowledge,
    required this.onNavigateToSpreads,
    required this.onNavigateToAstrology,
    required this.onNavigateToKabbalah,
    required this.onNavigateToMoonPowers,
  });

  final CommonStrings strings;
  final VoidCallback onNavigateToCards;
  final VoidCallback onNavigateToKnowledge;
  final VoidCallback onNavigateToSpreads;
  final VoidCallback onNavigateToAstrology;
  final VoidCallback onNavigateToKabbalah;
  final VoidCallback onNavigateToMoonPowers;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LearnPanel(
          strings: strings,
          onNavigateToCards: onNavigateToCards,
          onNavigateToKnowledge: onNavigateToKnowledge,
          onNavigateToSpreads: onNavigateToSpreads,
          onNavigateToAstrology: onNavigateToAstrology,
          onNavigateToKabbalah: onNavigateToKabbalah,
          onNavigateToMoonPowers: onNavigateToMoonPowers,
        ),
      ],
    );
  }
}
