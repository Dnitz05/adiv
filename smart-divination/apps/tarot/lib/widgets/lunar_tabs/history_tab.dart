import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../lunar_advice_history_panel.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    super.key,
    required this.strings,
    this.userId,
  });

  final CommonStrings strings;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LunarAdviceHistoryPanel(
            strings: strings,
            userId: userId,
            locale: strings.localeName,
            onShareAdvice: (message) {
              // Handle sharing advice
            },
          ),
        ],
      ),
    );
  }
}
