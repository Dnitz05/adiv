import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/lunar_day.dart';
import '../../models/lunar_ritual.dart';
import '../../theme/tarot_theme.dart';

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
  String _selectedFilter = 'all'; // all, phase, category

  @override
  Widget build(BuildContext context) {
    final rituals = _selectedFilter == 'phase'
        ? LunarRitualRepository.getRitualsForPhase(widget.day.phaseId)
        : LunarRitualRepository.allRituals;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 16),
          ...rituals.map((ritual) => _buildRitualCard(ritual, context)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.3),
            TarotTheme.cosmicPurple.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _localisedLabel('lunar_rituals'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _localisedLabel('rituals_subtitle'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterChip(
            'all',
            _localisedLabel('all_rituals'),
            Icons.list,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterChip(
            'phase',
            _localisedLabel('for_this_phase'),
            Icons.brightness_3,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? TarotTheme.cosmicAccent.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.2),
          border: isSelected
              ? Border.all(color: TarotTheme.cosmicAccent, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRitualCard(LunarRitual ritual, BuildContext context) {
    final locale = widget.strings.localeName;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            _getCategoryColor(ritual.category).withValues(alpha: 0.2),
            _getCategoryColor(ritual.category).withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: _getCategoryColor(ritual.category).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showRitualDetails(ritual, context),
          child: Padding(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
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
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  ritual.getDescription(locale),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ritual.getIntentions(locale).take(3).map((intention) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      child: Text(
                        intention,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                        ),
                      ),
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
        color: Colors.white.withValues(alpha: 0.15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
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
      'rituals_subtitle': {
        'en': 'Sacred practices for each moon phase',
        'es': 'Prácticas sagradas para cada fase lunar',
        'ca': 'Pràctiques sagrades per cada fase lunar'
      },
      'all_rituals': {'en': 'All Rituals', 'es': 'Todos', 'ca': 'Tots'},
      'for_this_phase': {'en': 'For This Phase', 'es': 'Para Esta Fase', 'ca': 'Per Aquesta Fase'},
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
