import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../models/lunar_day.dart';
import '../screens/chat_screen.dart';
import '../state/lunar_cycle_controller.dart';
import '../theme/tarot_theme.dart';
import 'lunar_ai_advisor.dart';
import 'lunar_tabs/today_tab.dart';
import 'lunar_tabs/calendar_tab.dart';
import 'lunar_tabs/rituals_tab.dart';
import 'lunar_tabs/spreads_tab.dart';
import 'lunar_tabs/guidance_tab.dart';
import 'lunar_tabs/history_tab.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

        // ✅ Widget únic amb cohesió visual completa
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCompactHeader(day),
              const SizedBox(height: 16),
              _buildAskTheMoonCard(context),
              const SizedBox(height: 16),
              _buildTabBar(),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: _buildTabContent(day),
              ),
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

  Widget _buildAskTheMoonCard(BuildContext context) {
    return LunarAiAdvisor(
      strings: widget.strings,
      userId: widget.userId,
      locale: widget.strings.localeName,
      onShareAdvice: (message) => _openAdviceInChat(context, message),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      _buildTab(_localisedTab('today'), Icons.today),
      _buildTab(_localisedTab('calendar'), Icons.calendar_month),
      _buildTab(_localisedTab('rituals'), Icons.auto_awesome),
      _buildTab(_localisedTab('spreads'), Icons.style),
      _buildTab(_localisedTab('guidance'), Icons.psychology),
      _buildTab(_localisedTab('history'), Icons.history),
    ];

    // ✅ TabBar integrat sense decoració redundant
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: TarotTheme.brightBlue,
          boxShadow: [
            BoxShadow(
              color: TarotTheme.brightBlue20,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: TarotTheme.softBlueGrey,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: tabs,
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(LunarDayModel day) {
    return TabBarView(
      controller: _tabController,
      children: [
        TodayTab(
          day: day,
          strings: widget.strings,
        ),
        CalendarTab(
          controller: widget.controller,
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
        GuidanceTab(
          day: day,
          strings: widget.strings,
        ),
        HistoryTab(
          strings: widget.strings,
          userId: widget.userId,
        ),
      ],
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

  String _localisedTab(String key) {
    final locale = widget.strings.localeName;
    final translations = {
      'today': {'en': 'Today', 'es': 'Hoy', 'ca': 'Avui'},
      'calendar': {'en': 'Calendar', 'es': 'Calendario', 'ca': 'Calendari'},
      'rituals': {'en': 'Rituals', 'es': 'Rituales', 'ca': 'Rituals'},
      'spreads': {'en': 'Spreads', 'es': 'Tiradas', 'ca': 'Tirades'},
      'guidance': {'en': 'Guidance', 'es': 'Guía', 'ca': 'Guia'},
      'history': {'en': 'History', 'es': 'Historial', 'ca': 'Historial'},
    };
    return translations[key]?[locale] ?? translations[key]?['en'] ?? key;
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
