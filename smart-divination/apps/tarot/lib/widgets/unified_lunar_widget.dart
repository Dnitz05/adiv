import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import 'package:uuid/uuid.dart';

import '../api/lunar_api.dart';
import '../models/chat_message.dart';
import '../models/lunar_advice.dart';
import '../models/lunar_day.dart';
import '../screens/chat_screen.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import 'lunar_tabs/today_tab.dart';
import 'lunar_tabs/calendar_only_tab.dart';
import 'lunar_tabs/phases_tab.dart';
import 'lunar_tabs/rituals_tab.dart';
import 'lunar_tabs/spreads_tab.dart';

class UnifiedLunarWidget extends StatefulWidget {
  const UnifiedLunarWidget({
    super.key,
    required this.controller,
    required this.strings,
    this.userId,
    this.onSelectSpread,
    this.onRefresh,
  });

  final LunarCycleController controller;
  final CommonStrings strings;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;
  final VoidCallback? onRefresh;

  @override
  State<UnifiedLunarWidget> createState() => _UnifiedLunarWidgetState();
}

class _UnifiedLunarWidgetState extends State<UnifiedLunarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Ask the Moon state
  final TextEditingController _intentionController = TextEditingController();
  final LunarApiClient _lunarApi = const LunarApiClient();
  LunarAdviceResponse? _lunarResponse;
  bool _isLoadingLunar = false;
  String? _lunarErrorMessage;
  bool _isAskExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _intentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final day = widget.controller.selectedDay;
        final status = widget.controller.status;

        if (status == LunarPanelStatus.loading && day == null) {
          return _buildLoadingState();
        }

        if (status == LunarPanelStatus.error && day == null) {
          return _buildErrorState(widget.controller.errorMessage);
        }

        if (day == null) {
          return _buildLoadingState();
        }

        // ✅ Widget unificat amb nova estructura optimitzada
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TarotTheme.lunarLavenderLight,
                TarotTheme.lunarLavenderSoft,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.lunarMysticShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: TarotTheme.lunarMysticShadow,
                blurRadius: 32,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCompactHeader(day),
              const SizedBox(height: 12),
              _buildTabBarHighlighted(),
              const SizedBox(height: 8),
              _buildTabContent(day),
              const SizedBox(height: 12),
              _buildCompactAskTheMoon(),
            ],
          ),
        );
      },
    );
  }

  // ✅ Header compacte integrat amb text fosc per màxima llegibilitat
  Widget _buildCompactHeader(LunarDayModel day) {
    return Row(
      children: [
        // Emoji fase lunar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: TarotTheme.brightBlue20,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            day.phaseEmoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 14),

        // Info principal
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day.phaseName,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    day.zodiac.symbol,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    day.zodiac.name,
                    style: const TextStyle(
                      color: TarotTheme.softBlueGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getElementColor(day.zodiac.element),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      day.zodiac.element,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Badge il·luminació
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: TarotTheme.brightBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.brightBlue20,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${day.illumination.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ TabBar destacada amb estil pills per identificació clara
  Widget _buildTabBarHighlighted() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [TarotTheme.brightBlue, TarotTheme.cosmicAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: TarotTheme.brightBlue.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: TarotTheme.softBlueGrey,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          _buildTab(_localisedTab('today'), Icons.today),
          _buildTab(_localisedTab('calendar'), Icons.calendar_month),
          _buildTab(_localisedTab('phases'), Icons.brightness_3),
          _buildTab(_localisedTab('rituals'), Icons.auto_awesome),
          _buildTab(_localisedTab('spreads'), Icons.style),
        ],
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  // ✅ Tab content optimitzat amb height reduït i padding ajustat
  Widget _buildTabContent(LunarDayModel day) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: TabBarView(
        controller: _tabController,
        children: [
          TodayTab(
            day: day,
            strings: widget.strings,
          ),
          CalendarOnlyTab(
            controller: widget.controller,
            strings: widget.strings,
          ),
          PhasesTab(
            day: day,
            strings: widget.strings,
          ),
          RitualsTab(
            day: day,
            strings: widget.strings,
            userId: widget.userId,
          ),
          SpreadsTab(
            day: day,
            strings: widget.strings,
            onSelectSpread: widget.onSelectSpread,
          ),
        ],
      ),
    );
  }

  // ✅ Ask the Moon compacte amb layout horizontal col·lapsable
  Widget _buildCompactAskTheMoon() {
    final hasContent = _lunarResponse != null || _lunarErrorMessage != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(
        minHeight: 56,
        maxHeight: (_isAskExpanded || hasContent) ? 400 : 56,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row principal sempre visible
            Row(
              children: [
                // Icon gradient circular
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [TarotTheme.brightBlue, TarotTheme.cosmicAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                // TextField expandit
                Expanded(
                  child: TextField(
                    controller: _intentionController,
                    decoration: InputDecoration(
                      hintText: _localisedAskPlaceholder(),
                      hintStyle: TextStyle(
                        color: TarotTheme.midnightBlue.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: TarotTheme.midnightBlue,
                      fontSize: 13,
                    ),
                    maxLines: _isAskExpanded ? 3 : 1,
                    onTap: () {
                      if (!_isAskExpanded) {
                        setState(() {
                          _isAskExpanded = true;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Botó circular
                IconButton.filled(
                  onPressed: _isLoadingLunar ? null : _handleRequestLunarAdvice,
                  icon: _isLoadingLunar
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: TarotTheme.brightBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            // Contingut expandit
            if (_isAskExpanded && hasContent) ...[
              const SizedBox(height: 12),
              if (_lunarResponse != null) _buildLunarAdviceResult(_lunarResponse!),
              if (_lunarErrorMessage != null) _buildLunarErrorState(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const SizedBox(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.strings.lunarPanelLoading,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: 12),
          Text(
            message ?? widget.strings.lunarPanelError,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          if (widget.onRefresh != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(widget.strings.lunarPanelRetry),
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [
          TarotTheme.lunarLavenderLight,
          TarotTheme.lunarLavenderSoft,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: TarotTheme.lunarMysticShadow,
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = _getMonthNames();
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return isoDate;
    }
  }

  List<String> _getMonthNames() {
    switch (widget.strings.localeName) {
      case 'ca':
        return [
          'Gener',
          'Febrer',
          'Març',
          'Abril',
          'Maig',
          'Juny',
          'Juliol',
          'Agost',
          'Setembre',
          'Octubre',
          'Novembre',
          'Desembre'
        ];
      case 'es':
        return [
          'Enero',
          'Febrero',
          'Marzo',
          'Abril',
          'Mayo',
          'Junio',
          'Julio',
          'Agosto',
          'Septiembre',
          'Octubre',
          'Noviembre',
          'Diciembre'
        ];
      default:
        return [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
    }
  }

  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
      case 'foc':
      case 'fuego':
        return const Color(0xFFFF6B35); // Warm coral-orange
      case 'earth':
      case 'terra':
      case 'tierra':
        return const Color(0xFF2ECC71); // Fresh green
      case 'air':
      case 'aire':
        return const Color(0xFF54C5F8); // Sky blue
      case 'water':
      case 'aigua':
      case 'agua':
        return const Color(0xFF4A90E2); // Ocean blue
      default:
        return TarotTheme.brightBlue;
    }
  }

  // ✅ Gestió de l'API lunar
  Future<void> _handleRequestLunarAdvice() async {
    setState(() {
      _isLoadingLunar = true;
      _lunarErrorMessage = null;
      _isAskExpanded = true;
    });

    try {
      final response = await _lunarApi.fetchAdvice(
        topic: LunarAdviceTopic.projects,
        intention: _intentionController.text.trim(),
        locale: widget.strings.localeName,
        userId: widget.userId,
      );
      if (!mounted) return;
      setState(() {
        _lunarResponse = response;
        _isLoadingLunar = false;
      });
    } on LunarApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _lunarErrorMessage = error.message;
        _isLoadingLunar = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _lunarErrorMessage = error.toString();
        _isLoadingLunar = false;
      });
    }
  }

  Widget _buildLunarAdviceResult(LunarAdviceResponse response) {
    final advice = response.advice;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TarotTheme.skyBlueSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            advice.focus,
            style: const TextStyle(
              color: TarotTheme.midnightBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          ...advice.today.take(2).map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
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
                          style: TextStyle(
                            color: TarotTheme.midnightBlue.withValues(alpha: 0.85),
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${advice.next.name} · ${advice.next.date}',
                  style: const TextStyle(
                    color: TarotTheme.midnightBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  advice.next.advice,
                  style: TextStyle(
                    color: TarotTheme.midnightBlue.withValues(alpha: 0.8),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _handleShareLunarAdvice(advice),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: Text(
                _localisedShareText(),
                style: const TextStyle(fontSize: 12),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLunarErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _lunarErrorMessage ?? _localisedRetryText(),
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 12,
            ),
          ),
          TextButton(
            onPressed: _handleRequestLunarAdvice,
            child: Text(
              _localisedRetryText(),
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  void _handleShareLunarAdvice(LunarAdvice advice) {
    final buffer = StringBuffer()
      ..writeln(advice.focus)
      ..writeln();

    for (final item in advice.today) {
      buffer.writeln('- $item');
    }

    buffer
      ..writeln()
      ..writeln('${advice.next.name} (${advice.next.date}) -> ${advice.next.advice}');

    _openAdviceInChat(context, buffer.toString().trim());
  }

  String _localisedTab(String key) {
    final locale = widget.strings.localeName;
    final translations = {
      'today': {'en': 'Today', 'es': 'Hoy', 'ca': 'Avui'},
      'calendar': {'en': 'Calendar', 'es': 'Calendario', 'ca': 'Calendari'},
      'phases': {'en': 'Phases', 'es': 'Fases', 'ca': 'Fases'},
      'rituals': {'en': 'Rituals', 'es': 'Rituales', 'ca': 'Rituals'},
      'spreads': {'en': 'Spreads', 'es': 'Tiradas', 'ca': 'Tirades'},
    };
    return translations[key]?[locale] ?? translations[key]?['en'] ?? key;
  }

  String _localisedAskPlaceholder() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Ej: Preparar un lanzamiento...';
      case 'ca':
        return 'Ex: Preparar un llançament...';
      default:
        return 'Ex: Launch a project...';
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

  void _openAdviceInChat(BuildContext context, String message) {
    final activeUserId = widget.userId;
    if (activeUserId == null || activeUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_localisedLoginPrompt()),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    final chatMessage = ChatMessage.text(
      id: const Uuid().v4(),
      isUser: false,
      timestamp: DateTime.now(),
      text: message,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: activeUserId,
          strings: widget.strings,
          initialMessages: [chatMessage],
        ),
      ),
    );
  }

  String _localisedLoginPrompt() {
    switch (widget.strings.localeName) {
      case 'es':
        return 'Inicia sesión para compartir tu consejo lunar en el chat.';
      case 'ca':
        return 'Inicia sessió per compartir el teu consell lunar al xat.';
      default:
        return 'Sign in to share your lunar guidance in the chat.';
    }
  }
}
