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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          Text(
            _localisedHeaderSubtitle(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TarotTheme.midnightBlue.withValues(alpha: 0.7),
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 12),
          _buildIntentionField(context),
          const SizedBox(height: 12),
          _buildActionButton(context),
          const SizedBox(height: 12),
          _buildStatusArea(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: TarotTheme.skyBlueSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.calendar_month,
            color: TarotTheme.brightBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _localisedHeaderTitle(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TarotTheme.midnightBlue,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntentionField(BuildContext context) {
    return TextField(
      controller: _intentionController,
      maxLines: 2,
      minLines: 1,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: TarotTheme.midnightBlue),
      decoration: InputDecoration(
        hintText: _localisedIntentionPlaceholder(),
        hintStyle: const TextStyle(color: TarotTheme.midnightBlue70),
        filled: true,
        fillColor: TarotTheme.skyBlueSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final label = _localisedAskButton();
    return FilledButton.icon(
      onPressed: _isLoading ? null : _handleRequestAdvice,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        backgroundColor: TarotTheme.brightBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildStatusArea(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState(context);
    }
    if (_errorMessage != null) {
      return _buildErrorState(context);
    }
    if (_response != null) {
      return _buildAdviceResult(context, _response!);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _localisedLoadingText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TarotTheme.midnightBlue,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _errorMessage ?? _localisedRetryText(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red[700],
                ),
          ),
          TextButton(
            onPressed: _handleRequestAdvice,
            child: Text(_localisedRetryText()),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceResult(BuildContext context, LunarAdviceResponse response) {
    final advice = response.advice;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TarotTheme.skyBlueSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            advice.focus,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: TarotTheme.midnightBlue,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          ...advice.today.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                        color: TarotTheme.midnightBlue,
                        fontWeight: FontWeight.w700,
                      )),
                  Expanded(
                    child: Text(
                      line,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TarotTheme.midnightBlue.withValues(alpha: 0.85),
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
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _handleShareAdvice(advice),
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(_localisedShareText()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPhaseChip(BuildContext context, LunarAdvice advice) {
    final label = '${advice.next.name} · ${advice.next.date}';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: TarotTheme.midnightBlue,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            advice.next.advice,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TarotTheme.midnightBlue.withValues(alpha: 0.8),
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
        topic: _advisorTopic,
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      border: Border.all(
        color: TarotTheme.skyBlueSoft,
        width: 1,
      ),
    );
  }

  LunarAdviceTopic get _advisorTopic => LunarAdviceTopic.projects;

  String _localisedHeaderTitle() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Pregunta a la luna';
      case 'ca':
        return 'Pregunta a la lluna';
      default:
        return 'Ask the moon';
    }
  }

  String _localisedHeaderSubtitle() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Explica el ritual o proyecto i te orienta con el mejor momentum lunar.';
      case 'ca':
        return 'Descriu el ritual o projecte i rebràs el millor moment lunar.';
      default:
        return 'Describe your plan and get the best lunar timing.';
    }
  }

  String _localisedPromptHelper() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Comparte lo que quieres iniciar, cuidar o cerrar y obtén el enfoque lunar recomendado.';
      case 'ca':
        return 'Explica què vols iniciar, cuidar o tancar i rep l’enfocament lunar recomanat.';
      default:
        return 'Share what you want to launch, nurture or close and get the recommended lunar focus.';
    }
  }

  String _localisedIntentionPlaceholder() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Ej: Preparar un llançament o cuidar una relació';
      case 'ca':
        return 'Ex: Preparar un llançament o cuidar un vincle';
      default:
        return 'Ex: Launch a project or slow down to rest';
    }
  }

  String _localisedAskButton() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Consultar a la luna';
      case 'ca':
        return 'Consultar la lluna';
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
