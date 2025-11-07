import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../api/lunar_api.dart';
import '../models/lunar_advice.dart';
import '../theme/tarot_theme.dart';

class LunarAiAdvisor extends StatefulWidget {
  const LunarAiAdvisor({
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
  State<LunarAiAdvisor> createState() => _LunarAiAdvisorState();
}

class _LunarAiAdvisorState extends State<LunarAiAdvisor> {
  final LunarApiClient _api = const LunarApiClient();
  final TextEditingController _intentionController = TextEditingController();

  LunarAdviceResponse? _response;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _intentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildHowToAskSection(context),
          const SizedBox(height: 14),
          _buildIntentionField(context),
          const SizedBox(height: 16),
          _buildActionButton(context),
          const SizedBox(height: 16),
          if (_isLoading) _buildLoadingState(context),
          if (!_isLoading && _errorMessage != null) _buildErrorState(context),
          if (!_isLoading && _response != null) _buildAdviceResult(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _localisedHeaderTitle(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          _localisedHeaderSubtitle(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
        ),
      ],
    );
  }

  Widget _buildHowToAskSection(BuildContext context) {
    final theme = Theme.of(context);
    final tips = _localisedInstructionTips();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localisedInstructionTitle(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntentionField(BuildContext context) {
    return TextField(
      controller: _intentionController,
      maxLines: 2,
      minLines: 1,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: _localisedIntentionPlaceholder(),
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final label = _localisedAskButton();
    return FilledButton(
      onPressed: _isLoading ? null : _handleRequestAdvice,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: TarotTheme.cosmicBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.auto_awesome, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _localisedLoadingText(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.3,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[400]!.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _errorMessage ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: _isLoading ? null : _handleRequestAdvice,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(_localisedRetryText()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceResult(BuildContext context) {
    final advice = _response!.advice;
    final contextInfo = _response!.context;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            advice.focus,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 12),
          ...advice.today.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.white, height: 1.4)),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildNextPhaseChip(context, advice),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${contextInfo.phaseEmoji} ${contextInfo.phaseName}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              TextButton.icon(
                onPressed: () => _handleShareAdvice(advice),
                icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white70),
                label: Text(
                  _localisedShareText(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextPhaseChip(BuildContext context, LunarAdvice advice) {
    final label = '${advice.next.name} • ${advice.next.date}';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            advice.next.advice,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRequestAdvice() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _api.fetchAdvice(
        topic: _selectedTopic,
        intention: _intentionController.text.trim(),
        locale: widget.locale ?? widget.strings.localeName,
        userId: widget.userId,
      );
      if (!mounted) return;
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } on LunarApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _handleShareAdvice(LunarAdvice advice) {
    if (widget.onShareAdvice == null) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln(advice.focus)
      ..writeln();

    for (final item in advice.today) {
      buffer.writeln('- $item');
    }

    buffer
      ..writeln()
      ..writeln('${advice.next.name} (${advice.next.date}) -> ${advice.next.advice}');

    widget.onShareAdvice!(buffer.toString().trim());
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        colors: [
          TarotTheme.cosmicBlue,
          TarotTheme.cosmicPurple,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: TarotTheme.cosmicPurple.withValues(alpha: 0.25),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  String _localisedHeaderTitle() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Consejo lunar con IA';
      case 'ca':
        return 'Consell lunar amb IA';
      default:
        return 'Lunar guidance with AI';
    }
  }

  String _localisedHeaderSubtitle() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Elige un tema y deja que la luna marque tus pasos.';
      case 'ca':
        return 'Tria un tema i deixa que la lluna marqui els teus passos.';
      default:
        return 'Choose a theme and let the moon suggest your next moves.';
    }
  }

  String _localisedTopicLabel(LunarAdviceTopic topic) {
    switch (widget.strings.localeName) {
      case 'es':
        switch (topic) {
          case LunarAdviceTopic.intentions:
            return 'Intenciones';
          case LunarAdviceTopic.projects:
            return 'Proyectos';
          case LunarAdviceTopic.relationships:
            return 'Relaciones';
          case LunarAdviceTopic.wellbeing:
            return 'Bienestar';
          case LunarAdviceTopic.creativity:
            return 'Creatividad';
        }
      case 'ca':
        switch (topic) {
          case LunarAdviceTopic.intentions:
            return 'Intencions';
          case LunarAdviceTopic.projects:
            return 'Projectes';
          case LunarAdviceTopic.relationships:
            return 'Relacions';
          case LunarAdviceTopic.wellbeing:
            return 'Benestar';
          case LunarAdviceTopic.creativity:
            return 'Creativitat';
        }
      default:
        switch (topic) {
          case LunarAdviceTopic.intentions:
            return 'Intentions';
          case LunarAdviceTopic.projects:
            return 'Projects';
          case LunarAdviceTopic.relationships:
            return 'Relationships';
          case LunarAdviceTopic.wellbeing:
            return 'Wellbeing';
          case LunarAdviceTopic.creativity:
            return 'Creativity';
        }
    }
  }

  String _localisedIntentionPlaceholder() {
    switch (widget.strings.localeName) {
      case 'es':
        return '¿Cuál es tu intención o deseo hoy? (opcional)';
      case 'ca':
        return 'Quina és la teva intenció o desig avui? (opcional)';
      default:
        return 'What is your intention today? (optional)';
    }
  }

  String _localisedAskButton() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Preguntar a la luna';
      case 'ca':
        return 'Preguntar a la lluna';
      default:
        return 'Ask the moon';
    }
  }

  String _localisedLoadingText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'La luna está preparando tu consejo...';
      case 'ca':
        return 'La lluna està preparant el teu consell...';
      default:
        return 'The moon is crafting your guidance...';
    }
  }

  String _localisedRetryText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Intentar de nuevo';
      case 'ca':
        return 'Tornar a intentar';
      default:
        return 'Try again';
    }
  }

  String _localisedShareText() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Abrir en el chat';
      case 'ca':
        return 'Obrir al xat';
      default:
        return 'Open in chat';
    }
  }
}
