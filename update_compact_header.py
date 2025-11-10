import re

# Read the file
with open('smart-divination/apps/tarot/lib/widgets/unified_lunar_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# New implementation with 3 sections
new_implementation = '''  Widget _buildCompactHeader() {
    final lunarInfo = LunarInfoHelper(widget.day);
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final formattedDate = '${widget.day.date.day} ${months[widget.day.date.month - 1]}';
    final lunarDay = 'Day ${widget.day.age.round()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeroSection(lunarInfo),
        const SizedBox(height: 4),
        _buildAstroSection(lunarInfo),
        const SizedBox(height: 4),
        _buildTimelineSection(formattedDate, lunarDay, lunarInfo),
      ],
    );
  }

  // SECTION 1: Hero - What is the moon today?
  Widget _buildHeroSection(LunarInfoHelper lunarInfo) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // Moon emoji with glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: TarotTheme.brightBlue.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              widget.day.phaseEmoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 14),
          // Phase name and trend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.day.phaseName,
                  style: const TextStyle(
                    color: TarotTheme.deepNavy,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Fase lunar · ${lunarInfo.trend}',
                  style: TextStyle(
                    color: TarotTheme.softBlueGrey.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Illumination badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: TarotTheme.brightBlue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: TarotTheme.brightBlue.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${widget.day.illumination.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 2: Astro - Where is the moon?
  Widget _buildAstroSection(LunarInfoHelper lunarInfo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TarotTheme.cosmicAccent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Row 1: Zodiac + Element
          Row(
            children: [
              Text(
                widget.day.zodiac.symbol,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Luna en ${widget.day.zodiac.name}',
                style: const TextStyle(
                  color: TarotTheme.deepNavy,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TarotTheme.getElementColor(widget.day.zodiac.element),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.day.zodiac.element,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Properties (Polarity · Quality · Ruler)
          Row(
            children: [
              Text(
                '${lunarInfo.polarity} · ${lunarInfo.quality} · ${lunarInfo.ruler}',
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SECTION 3: Timeline - When?
  Widget _buildTimelineSection(String formattedDate, String lunarDay, LunarInfoHelper lunarInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, size: 12, color: TarotTheme.brightBlue.withValues(alpha: 0.7)),
              const SizedBox(width: 5),
              Text(
                formattedDate,
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Separator dot
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TarotTheme.softBlueGrey.withValues(alpha: 0.3),
            ),
          ),
          // Lunar day
          Row(
            children: [
              Icon(Icons.brightness_3, size: 12, color: TarotTheme.cosmicAccent.withValues(alpha: 0.7)),
              const SizedBox(width: 5),
              Text(
                lunarDay,
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Separator dot
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TarotTheme.softBlueGrey.withValues(alpha: 0.3),
            ),
          ),
          // Next phase
          Row(
            children: [
              Icon(Icons.arrow_forward, size: 12, color: TarotTheme.cosmicPurple.withValues(alpha: 0.7)),
              const SizedBox(width: 5),
              Text(
                '${lunarInfo.nextPhase} in ${lunarInfo.daysToNext}d',
                style: TextStyle(
                  color: TarotTheme.softBlueGrey.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }'''

# Find and replace from _buildCompactHeader() until (and including) _buildInfoPill()
start_pattern = r'  Widget _buildCompactHeader\(\) \{'
end_pattern = r'  Widget _buildUnifiedTabsContainer\(\)'

# Find the start
start_match = re.search(start_pattern, content)
if start_match:
    start_pos = start_match.start()

    # Find the end (next method after _buildInfoPill)
    end_match = re.search(end_pattern, content[start_pos:])
    if end_match:
        end_pos = start_pos + end_match.start()

        # Replace everything between start and end with new implementation
        content = content[:start_pos] + new_implementation + '\n\n' + content[end_pos:]

        # Write back
        with open('smart-divination/apps/tarot/lib/widgets/unified_lunar_widget.dart', 'w', encoding='utf-8') as f:
            f.write(content)

        print("✅ Header successfully updated with 3-section compact design!")
        print("  - Section 1: Hero (Moon phase + illumination)")
        print("  - Section 2: Astro (Zodiac + properties)")
        print("  - Section 3: Timeline (Date + lunar day + next phase)")
    else:
        print("❌ Could not find end pattern")
else:
    print("❌ Could not find start pattern")
