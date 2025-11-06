import 'package:flutter/material.dart';

import 'package:common/l10n/common_strings.dart';

import '../api/lunar_api.dart';
import '../models/lunar_advice_history.dart';
import '../theme/tarot_theme.dart';

class LunarAdviceHistoryPanel extends StatefulWidget {
  const LunarAdviceHistoryPanel({
    super.key,
    required this.strings,
    this.userId,
    this.locale,
    this.onShareAdvice,
  });

  final CommonStrings strings;
  final String? userId;
  final String? locale;
  final ValueChanged<String>? onShareAdvice;

  @override
  State<LunarAdviceHistoryPanel> createState() => _LunarAdviceHistoryPanelState();
}

class _LunarAdviceHistoryPanelState extends State<LunarAdviceHistoryPanel> {
  final LunarApiClient _api = const LunarApiClient();
  Future<List<LunarAdviceHistoryItem>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _loadHistory();
  }

  Future<List<LunarAdviceHistoryItem>> _loadHistory() async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      return <LunarAdviceHistoryItem>[];
    }
    try {
      return await _api.fetchAdviceHistory(
        userId: widget.userId,
        locale: widget.locale ?? widget.strings.localeName,
        limit: 5,
      );
    } on LunarApiException {
      return <LunarAdviceHistoryItem>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LunarAdviceHistoryItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildContainer(
            context,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildContainer(
            context,
            child: Text(
              _localisedError(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          );
        }

        final items = snapshot.data ?? <LunarAdviceHistoryItem>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildContainer(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localisedTitle(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              ...items.take(3).map((item) => _HistoryCard(
                    item: item,
                    strings: widget.strings,
                    onShareAdvice: widget.onShareAdvice,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainer(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicPurple.withValues(alpha: 0.8),
            TarotTheme.cosmicBlue.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.cosmicPurple.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }

  String _localisedTitle() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Consejos recientes';
      case 'ca':
        return 'Consells recents';
      default:
        return 'Recent guidance';
    }
  }

  String _localisedError() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'No se pudo cargar el historial lunar.';
      case 'ca':
        return 'No s\'ha pogut carregar l\'historial lunar.';
      default:
        return 'Could not load lunar history.';
    }
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.item,
    required this.strings,
    this.onShareAdvice,
  });

  final LunarAdviceHistoryItem item;
  final CommonStrings strings;
  final ValueChanged<String>? onShareAdvice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = _formatDate(item.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                _localisedTopic(item.topic),
                style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white54,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.advice.focus,
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          if (item.advice.today.isNotEmpty)
            Text(
              '- ${item.advice.today.first}',
              style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
            ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onShareAdvice == null
                ? null
                : () => onShareAdvice!(_buildShareMessage(item)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: Text(_localisedShare()),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _localisedTopic(String topic) {
    switch (strings.localeName) {
      case 'es':
        switch (topic) {
          case 'projects':
            return 'Proyectos';
          case 'relationships':
            return 'Relaciones';
          case 'wellbeing':
            return 'Bienestar';
          case 'creativity':
            return 'Creatividad';
          default:
            return 'Intenciones';
        }
      case 'ca':
        switch (topic) {
          case 'projects':
            return 'Projectes';
          case 'relationships':
            return 'Relacions';
          case 'wellbeing':
            return 'Benestar';
          case 'creativity':
            return 'Creativitat';
          default:
            return 'Intencions';
        }
      default:
        switch (topic) {
          case 'projects':
            return 'Projects';
          case 'relationships':
            return 'Relationships';
          case 'wellbeing':
            return 'Wellbeing';
          case 'creativity':
            return 'Creativity';
          default:
            return 'Intentions';
        }
    }
  }

  String _localisedShare() {
    switch (strings.localeName) {
      case 'es':
        return 'Compartir en el chat';
      case 'ca':
        return 'Compartir al xat';
      default:
        return 'Share in chat';
    }
  }

  String _buildShareMessage(LunarAdviceHistoryItem history) {
    final buffer = StringBuffer()
      ..writeln(history.advice.focus)
      ..writeln();
    for (final entry in history.advice.today.take(3)) {
      buffer.writeln('- $entry');
    }
    buffer
      ..writeln()
      ..writeln('${history.advice.next.name} (${history.advice.next.date}) -> ${history.advice.next.advice}');
    return buffer.toString().trim();
  }
}
