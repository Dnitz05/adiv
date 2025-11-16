import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../models/lunar_guide.dart';
import '../../theme/tarot_theme.dart';
import '../../services/lunar_guide_service.dart';
import '../../services/lunar_calculator_service.dart';

/// Guide Tab - Shows daily lunar guidance
/// Combines base templates + seasonal overlays + weekday energies + special events
/// ZERO AI cost - uses pre-written modular astrological content
class GuideTab extends StatefulWidget {
  const GuideTab({
    super.key,
    required this.day,
    required this.strings,
  });

  final LunarDayModel day;
  final CommonStrings strings;

  @override
  State<GuideTab> createState() => _GuideTabState();
}

class _GuideTabState extends State<GuideTab> {
  final LunarGuideService _guideService = LunarGuideService();
  final LunarCalculatorService _calculator = LunarCalculatorService();

  LunarGuide? _guide;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGuide();
  }

  Future<void> _loadGuide() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final guide = await _guideService.getTodaysGuide();
      setState(() {
        _guide = guide;
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
    if (_isLoading) {
      return _buildLoading();
    }

    if (_error != null) {
      return _buildError();
    }

    if (_guide == null) {
      return _buildEmpty();
    }

    return _buildGuideContent();
  }

  Widget _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.brightBlue.withValues(alpha: 0.03),
            TarotTheme.brightBlue.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: TarotTheme.brightBlue,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.brightBlue.withValues(alpha: 0.03),
            TarotTheme.brightBlue.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: TarotTheme.softBlueGrey, size: 32),
            const SizedBox(height: 8),
            Text(
              'Error loading guide',
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _error ?? 'Unknown error',
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadGuide,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: TarotTheme.brightBlue),
                foregroundColor: TarotTheme.brightBlue,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.brightBlue.withValues(alpha: 0.03),
            TarotTheme.brightBlue.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'No guide available',
          style: TextStyle(
            color: TarotTheme.softBlueGrey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildGuideContent() {
    final guide = _guide!;
    final template = guide.template;
    final dailyInsight = guide.dailyInsight;
    final locale = widget.strings.localeName;

    // Use composed content if available, otherwise fallback to template
    final hasComposedInsight = dailyInsight != null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TarotTheme.brightBlue.withValues(alpha: 0.03),
            TarotTheme.brightBlue.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Guide Header (uses composed headline if available)
            _buildGuideHeader(
              template,
              dailyInsight,
              locale,
            ),
            const SizedBox(height: 12),

            // Today's Description (modular-composed or template energy)
            _buildDescription(
              template,
              dailyInsight,
              locale,
              hasComposedInsight,
            ),
            const SizedBox(height: 12),

            // Focus Areas (composed or template)
            _buildFocusAreas(
              template,
              dailyInsight,
              locale,
            ),
            const SizedBox(height: 12),

            // Guidance (if composed content available)
            if (hasComposedInsight) ...[
              _buildGuidance(dailyInsight, locale),
              const SizedBox(height: 12),
            ],

            // Recommended Actions (composed or template)
            _buildRecommendedActions(
              template,
              dailyInsight,
              locale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideHeader(
    LunarGuideTemplate template,
    DailyLunarInsight? dailyInsight,
    String locale,
  ) {
    final lunarData = _calculator.calculateLunarPhase(DateTime.now());
    final phaseId = template.phaseId;
    final element = template.element ?? 'fire';
    final zodiacSign = _calculator.getZodiacSign(DateTime.now());

    // Use composed headline if available, otherwise template headline
    final headline =
        dailyInsight?.getHeadline(locale) ?? template.getHeadline(locale);

    return Row(
      children: [
        // Phase Emoji
        Text(
          _calculator.getPhaseEmoji(phaseId),
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(width: 12),

        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline
              Text(
                headline,
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Zodiac + Element + Weekday (if composed)
              Row(
                children: [
                  Text(
                    _calculator.getZodiacEmoji(zodiacSign),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _calculator.getElementIcon(element),
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (dailyInsight != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '• ${dailyInsight.weekday}',
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      template.getTagline(locale) ?? '',
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(
    LunarGuideTemplate template,
    DailyLunarInsight? dailyInsight,
    String locale,
    bool hasComposedInsight,
  ) {
    // Use composed description if available, otherwise template energy
    final description = dailyInsight?.getDescription(locale) ??
        template.getEnergyDescription(locale);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TarotTheme.cosmicAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: TarotTheme.cosmicAccent, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Today\'s Energy',
                style: TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasComposedInsight) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Composed',
                    style: TextStyle(
                      color: TarotTheme.cosmicAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: TarotTheme.deepNavy,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusAreas(
    LunarGuideTemplate template,
    DailyLunarInsight? dailyInsight,
    String locale,
  ) {
    // Use composed focus areas if available, otherwise template focus areas
    final focusAreas =
        dailyInsight?.getFocusAreas(locale) ?? template.getFocusAreas(locale);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: focusAreas.map((keyword) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: TarotTheme.brightBlue20,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            keyword,
            style: const TextStyle(
              color: TarotTheme.brightBlue,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGuidance(DailyLunarInsight dailyInsight, String locale) {
    final guidance = dailyInsight.getGuidance(locale);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TarotTheme.brightBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  color: TarotTheme.brightBlue, size: 14),
              const SizedBox(width: 6),
              const Text(
                'Guidance',
                style: TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            guidance,
            style: const TextStyle(
              color: TarotTheme.deepNavy,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedActions(
    LunarGuideTemplate template,
    DailyLunarInsight? dailyInsight,
    String locale,
  ) {
    // Use composed recommended actions if available, otherwise template actions
    final actions = dailyInsight?.getRecommendedActions(locale) ??
        template.getRecommendedActions(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 14),
            SizedBox(width: 6),
            Text(
              'Recommended Actions',
              style: TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...actions.take(5).map((action) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•',
                  style: TextStyle(
                    color: TarotTheme.brightBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    action,
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
