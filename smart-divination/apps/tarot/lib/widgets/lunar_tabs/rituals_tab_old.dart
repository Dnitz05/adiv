import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../models/lunar_ritual.dart';
import '../../theme/tarot_theme.dart';
import '../lunar_card_helpers.dart';

class RitualsTab extends StatefulWidget {
  const RitualsTab({
    super.key,
    required this.day,
    required this.strings,
    this.userId,
  });

  final LunarDayModel day;
  final CommonStrings strings;
  final String? userId;

  @override
  State<RitualsTab> createState() => _RitualsTabState();
}

class _RitualsTabState extends State<RitualsTab> {
  @override
  Widget build(BuildContext context) {
    // NO SCROLL - fixed height grid layout (3 columns × 2 rows)
    final allRitualsForPhase = LunarRitualRepository.getRitualsForPhase(widget.day.phaseId);
    final displayedRituals = allRitualsForPhase.take(6).toList(); // Max 6 rituals

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Compact header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: TarotTheme.cosmicAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                _localisedLabel('lunar_rituals'),
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                widget.day.phaseName,
                style: const TextStyle(
                  color: TarotTheme.softBlueGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildRitualsGrid(displayedRituals)),
      ],
    );
  }

  Widget _buildRitualsGrid(List<LunarRitual> rituals) {
    if (rituals.isEmpty) {
      return Center(
        child: Text(
          _localisedLabel('no_rituals'),
          style: const TextStyle(
            color: TarotTheme.softBlueGrey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // 3 columns × 2 rows = 6 rituals ultracompact
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.05,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: rituals.length,
      itemBuilder: (context, index) => _buildUltraCompactRitualCard(rituals[index]),
    );
  }

  Widget _buildUltraCompactRitualCard(LunarRitual ritual) {
    final locale = widget.strings.localeName;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showRitualDetails(ritual, context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                _getCategoryColor(ritual.category).withValues(alpha: 0.1),
                _getCategoryColor(ritual.category).withValues(alpha: 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: _getCategoryColor(ritual.category).withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ritual.iconEmoji,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 6),
              Text(
                ritual.getName(locale),
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${ritual.durationMinutes}m',
                style: const TextStyle(
                  color: TarotTheme.softBlueGrey,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewAllButton(List<LunarRitual> allRituals) {
    return FilledButton.icon(
      onPressed: () => _showAllRitualsDialog(allRituals),
      style: FilledButton.styleFrom(
        backgroundColor: TarotTheme.brightBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.grid_view, size: 18),
      label: Text(
        _localisedLabel('view_all_rituals'),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showAllRitualsDialog(List<LunarRitual> allRituals) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.day.phaseName} - ${_localisedLabel('all_rituals')}',
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: TarotTheme.deepNavy),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: allRituals.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRitualCard(allRituals[index], context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRitualCard(LunarRitual ritual, BuildContext context) {
    final locale = widget.strings.localeName;
    return LunarCardHelpers.buildWhiteCard(
      context: context,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showRitualDetails(ritual, context),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ritual.iconEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ritual.getName(locale),
                            style: LunarCardHelpers.cardTitleStyle,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildBadge(
                                '${ritual.durationMinutes} min',
                                Icons.access_time,
                              ),
                              const SizedBox(width: 8),
                              _buildBadge(
                                _localisedDifficulty(ritual.difficulty),
                                Icons.signal_cellular_alt,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: TarotTheme.softBlueGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  ritual.getDescription(locale),
                  style: LunarCardHelpers.cardBodyStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ritual.getIntentions(locale).take(3).map((intention) {
                    return LunarCardHelpers.buildBadge(
                      text: intention,
                      backgroundColor: _getCategoryColor(ritual.category).withValues(alpha: 0.2),
                      textColor: TarotTheme.deepNavy,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: TarotTheme.brightBlue10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: TarotTheme.softBlueGrey),
          const SizedBox(width: 4),
          Text(
            text,
            style: LunarCardHelpers.cardSmallStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showRitualDetails(LunarRitual ritual, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RitualDetailsSheet(
        ritual: ritual,
        locale: widget.strings.localeName,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'manifestation':
        return const Color(0xFFFFB74D); // Orange
      case 'release':
        return const Color(0xFF9575CD); // Purple
      case 'healing':
        return const Color(0xFF81C784); // Green
      case 'protection':
        return const Color(0xFF64B5F6); // Blue
      case 'abundance':
        return const Color(0xFFFFD54F); // Gold
      default:
        return TarotTheme.cosmicBlue;
    }
  }

  String _localisedDifficulty(String difficulty) {
    final locale = widget.strings.localeName;
    final labels = {
      'beginner': {'en': 'Beginner', 'es': 'Principiante', 'ca': 'Principiant'},
      'intermediate': {'en': 'Intermediate', 'es': 'Intermedio', 'ca': 'Intermedi'},
      'advanced': {'en': 'Advanced', 'es': 'Avanzado', 'ca': 'Avançat'},
    };
    return labels[difficulty]?[locale] ?? labels[difficulty]?['en'] ?? difficulty;
  }

  String _localisedLabel(String key) {
    final locale = widget.strings.localeName;
    final labels = {
      'lunar_rituals': {'en': 'Lunar Rituals', 'es': 'Rituales Lunares', 'ca': 'Rituals Lunars'},
      'all_rituals': {'en': 'All Rituals', 'es': 'Todos los Rituales', 'ca': 'Tots els Rituals'},
      'view_all_rituals': {'en': 'View All Rituals', 'es': 'Ver Todos', 'ca': 'Veure Tots'},
      'no_rituals': {'en': 'No rituals for this phase', 'es': 'No hay rituales para esta fase', 'ca': 'No hi ha rituals per aquesta fase'},
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }
}

// Ritual Details Bottom Sheet
class _RitualDetailsSheet extends StatelessWidget {
  final LunarRitual ritual;
  final String locale;

  const _RitualDetailsSheet({
    required this.ritual,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              _buildHandle(),
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSection('Materials Needed', Icons.checklist, ritual.getMaterials(locale)),
              const SizedBox(height: 24),
              _buildStepsSection(),
              const SizedBox(height: 24),
              _buildIntentionsSection(),
              const SizedBox(height: 32),
              _buildStartButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(ritual.iconEmoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ritual.getName(locale),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ritual.getDescription(locale),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: TarotTheme.cosmicAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.fiber_manual_record, color: TarotTheme.cosmicAccent, size: 8),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildStepsSection() {
    final steps = ritual.getSteps(locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.format_list_numbered, color: TarotTheme.cosmicAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'Steps',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...steps.map((step) => _buildStep(step)),
      ],
    );
  }

  Widget _buildStep(RitualStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Text(
                step.order.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntentionsSection() {
    final intentions = ritual.getIntentions(locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.energy_savings_leaf, color: TarotTheme.cosmicAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'Intentions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: intentions.map((intention) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    TarotTheme.cosmicBlue.withValues(alpha: 0.3),
                    TarotTheme.cosmicPurple.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Text(
                intention,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        // TODO: Start guided ritual
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: TarotTheme.cosmicAccent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Begin Ritual',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
