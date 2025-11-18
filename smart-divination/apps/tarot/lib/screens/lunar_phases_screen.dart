import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/lunar_guide_template.dart';
import '../services/lunar_guide_service.dart';
import '../theme/tarot_theme.dart';
import '../screens/lunar_phase_detail_screen.dart';

class LunarPhasesScreen extends StatefulWidget {
  const LunarPhasesScreen({
    super.key,
    required this.strings,
  });

  final CommonStrings strings;

  @override
  State<LunarPhasesScreen> createState() => _LunarPhasesScreenState();
}

class _LunarPhasesScreenState extends State<LunarPhasesScreen> {
  final LunarGuideService _lunarService = LunarGuideService();
  List<LunarGuideTemplate>? _templates;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load all 8 generic phase templates
      final templates = await _lunarService.getAllPhaseTemplates();
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.strings.localeName;

    return Scaffold(
      backgroundColor: TarotTheme.veryLightLilacBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TarotTheme.deepNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getTitle(locale),
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: TarotTheme.softBlueGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getErrorMessage(locale),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: TarotTheme.softBlueGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🌙', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 12),
                          Text(
                            _getHeaderTitle(locale),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getHeaderSubtitle(locale),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Phase templates
                    if (_templates != null)
                      ..._templates!.map(
                        (template) => _PhaseCard(
                          template: template,
                          locale: locale,
                          onTap: () => _navigateToPhaseDetail(template),
                        ),
                      ),
                  ],
                ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Fases Lunars';
      case 'es':
        return 'Fases Lunares';
      default:
        return 'Lunar Phases';
    }
  }

  String _getHeaderTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Les 8 Fases de la Lluna';
      case 'es':
        return 'Las 8 Fases de la Luna';
      default:
        return 'The 8 Phases of the Moon';
    }
  }

  String _getHeaderSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Cada fase lunar porta una energia única i saviesa ancestral. Explora el cicle complet.';
      case 'es':
        return 'Cada fase lunar trae una energía única y sabiduría ancestral. Explora el ciclo completo.';
      default:
        return 'Each lunar phase brings unique energy and ancient wisdom. Explore the complete cycle.';
    }
  }

  String _getErrorMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Error carregant les fases lunars. Si us plau, torna-ho a provar.';
      case 'es':
        return 'Error cargando las fases lunares. Por favor, inténtalo de nuevo.';
      default:
        return 'Error loading lunar phases. Please try again.';
    }
  }

  void _navigateToPhaseDetail(LunarGuideTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LunarPhaseDetailScreen(
          template: template,
          strings: widget.strings,
        ),
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.template,
    required this.locale,
    required this.onTap,
  });

  final LunarGuideTemplate template;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final phaseIcon = _getPhaseIcon(template.phaseId);
    final phaseColor = _getPhaseColor(template.phaseId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: phaseColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Phase icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    phaseIcon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.getHeadline(locale),
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.getTagline(locale) ?? '',
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: phaseColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPhaseIcon(String phaseId) {
    switch (phaseId) {
      case 'new_moon':
        return '🌑';
      case 'waxing_crescent':
        return '🌒';
      case 'first_quarter':
        return '🌓';
      case 'waxing_gibbous':
        return '🌔';
      case 'full_moon':
        return '🌕';
      case 'waning_gibbous':
        return '🌖';
      case 'last_quarter':
        return '🌗';
      case 'waning_crescent':
        return '🌘';
      default:
        return '🌙';
    }
  }

  Color _getPhaseColor(String phaseId) {
    switch (phaseId) {
      case 'new_moon':
        return const Color(0xFF1E293B); // Dark slate
      case 'waxing_crescent':
        return const Color(0xFF3B82F6); // Blue
      case 'first_quarter':
        return const Color(0xFF8B5CF6); // Violet
      case 'waxing_gibbous':
        return const Color(0xFFEC4899); // Pink
      case 'full_moon':
        return const Color(0xFFF59E0B); // Amber
      case 'waning_gibbous':
        return const Color(0xFF10B981); // Emerald
      case 'last_quarter':
        return const Color(0xFF06B6D4); // Cyan
      case 'waning_crescent':
        return const Color(0xFF6366F1); // Indigo
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}
