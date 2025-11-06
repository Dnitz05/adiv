import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/tarot_spread.dart';
import '../theme/tarot_theme.dart';

typedef StartThemeCallback = void Function({
  required SpreadThemeOption theme,
  required TarotSpread spread,
  String? question,
  String? displayLabel,
});

class SpreadsScreen extends StatefulWidget {
  const SpreadsScreen({
    super.key,
    required this.strings,
    required this.selectedSpread,
    required this.generalPrompt,
    required this.generalLabel,
    required this.onSelectSpread,
    required this.onStartTheme,
    required this.onOpenGallery,
  });

  final CommonStrings strings;
  final TarotSpread selectedSpread;
  final String generalPrompt;
  final String generalLabel;
  final ValueChanged<TarotSpread> onSelectSpread;
  final StartThemeCallback onStartTheme;
  final VoidCallback onOpenGallery;

  @override
  State<SpreadsScreen> createState() => _SpreadsScreenState();
}

class _SpreadsScreenState extends State<SpreadsScreen> {
  late final PageController _pageController;
  SpreadThemeOption _activeTheme = spreadThemes.first;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.86,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingBottom = mediaQuery.padding.bottom + 24;
    final locale = widget.strings.localeName;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: mediaQuery.padding.top + 12,
        bottom: paddingBottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(locale),
          const SizedBox(height: 24),
          _buildThemeCarousel(locale),
          const SizedBox(height: 24),
          _buildRecommendedSpreads(locale),
          const SizedBox(height: 32),
          _buildConsultationSpace(locale),
        ],
      ),
    );
  }

  Widget _buildHeader(String locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _resolve(locale,
              en: 'Choose the spread that fits your moment',
              es: 'Elige la tirada que encaja con tu momento',
              ca: 'Escull la tirada que encaixa amb el teu moment'),
          style: const TextStyle(
            color: TarotTheme.deepNight,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _resolve(locale,
              en:
                  'Swipe through themes to ask something general or focus on love, money, career and more.',
              es:
                  'Desliza por las temáticas para preguntar algo general o centrarte en amor, dinero, carrera y más.',
              ca:
                  'Passa el dit per les temàtiques per fer una consulta general o centrar-te en amor, diners, carrera i més.'),
          style: const TextStyle(
            color: Color(0xFF4E4E69),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCarousel(String locale) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _pageController,
            itemCount: spreadThemes.length,
            onPageChanged: (index) {
              setState(() {
                _activeTheme = spreadThemes[index];
              });
            },
            itemBuilder: (context, index) {
              final theme = spreadThemes[index];
              final isActive = theme.id == _activeTheme.id;
              return AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 6 : 12,
                  vertical: isActive ? 0 : 12,
                ),
                child: _ThemeCard(
                  theme: theme,
                  locale: locale,
                  isActive: isActive,
                  onStart: () => _handleStartTheme(theme, locale),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _PageIndicator(
          length: spreadThemes.length,
          controller: _pageController,
        ),
      ],
    );
  }

  Widget _buildRecommendedSpreads(String locale) {
    final theme = _activeTheme;
    final spreads = theme.recommendedSpreadIds
        .map(TarotSpreads.getById)
        .whereType<TarotSpread>()
        .toList();

    if (spreads.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _resolve(locale,
                  en: 'Recommended spreads',
                  es: 'Tiradas recomendadas',
                  ca: 'Tirades recomanades'),
              style: const TextStyle(
                color: TarotTheme.deepNight,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: widget.onOpenGallery,
              child: Text(
                _resolve(locale,
                    en: 'See all',
                    es: 'Ver todas',
                    ca: 'Veure totes'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: spreads.map((spread) {
            final isSelected = spread.id == widget.selectedSpread.id;
            return ChoiceChip(
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              selectedColor: TarotTheme.cosmicAccent.withValues(alpha: 0.2),
              side: BorderSide(
                color: isSelected
                    ? TarotTheme.cosmicAccent
                    : TarotTheme.cosmicAccentSubtle,
              ),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spread.localizedName(locale),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? TarotTheme.cosmicBlue
                          : TarotTheme.deepNight,
                    ),
                  ),
                  Text(
                    _resolve(locale,
                        en: '${spread.cardCount} cards',
                        es: '${spread.cardCount} cartas',
                        ca: '${spread.cardCount} cartes'),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B6B81),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => widget.onSelectSpread(spread),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConsultationSpace(String locale) {
    final theme = _activeTheme;
    final question = theme.questionBuilder?.call(locale) ?? widget.generalPrompt;
    final spread = theme.primarySpread ??
        TarotSpreads.getById(theme.recommendedSpreadIds.first) ??
        widget.selectedSpread;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            TarotTheme.midnightBlue,
            TarotTheme.deepNight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _resolve(locale,
                en: 'Consultation space',
                es: 'Espacio de consulta',
                ca: 'Espai de consulta'),
            style: const TextStyle(
              color: TarotTheme.cosmicAccent,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              height: 1.5,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 18),
          _ConsultationChips(
            label: widget.generalLabel,
            spreadName: spread.localizedName(locale),
            onTap: widget.onOpenGallery,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _handleStartTheme(theme, locale),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: TarotTheme.cosmicAccent,
                foregroundColor: TarotTheme.deepNight,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(
                _resolve(locale,
                    en: 'Start consultation',
                    es: 'Iniciar consulta',
                    ca: 'Inicia la consulta'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStartTheme(SpreadThemeOption theme, String locale) {
    final spread = theme.primarySpread ??
        TarotSpreads.getById(theme.recommendedSpreadIds.first) ??
        widget.selectedSpread;
    final question = theme.questionBuilder?.call(locale);
    final displayLabel =
        question?.isNotEmpty == true ? question!.trim() : widget.generalPrompt;

    widget.onStartTheme(
      theme: theme,
      spread: spread,
      question: question,
      displayLabel: displayLabel,
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.locale,
    required this.isActive,
    required this.onStart,
  });

  final SpreadThemeOption theme;
  final String locale;
  final bool isActive;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = [
      TarotTheme.cosmicBlue,
      TarotTheme.cosmicPurple,
      TarotTheme.cosmicAccent,
    ];
    final color = colors[math.Random(theme.id.hashCode).nextInt(colors.length)];

    return GestureDetector(
      onTap: onStart,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.95),
              TarotTheme.deepNight.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Icon(
                theme.icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              theme.titleBuilder(locale),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              theme.descriptionBuilder(locale),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: onStart,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                theme.ctaLabel(locale),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationChips extends StatelessWidget {
  const _ConsultationChips({
    required this.label,
    required this.spreadName,
    required this.onTap,
  });

  final String label;
  final String spreadName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        Chip(
          backgroundColor: Colors.white.withValues(alpha: 0.15),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Chip(
          backgroundColor: Colors.white.withValues(alpha: 0.08),
          label: Text(
            spreadName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text(
            '⋯',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class SpreadThemeOption {
  const SpreadThemeOption({
    required this.id,
    required this.icon,
    required this.titleBuilder,
    required this.descriptionBuilder,
    required this.recommendedSpreadIds,
    this.questionBuilder,
    this.primarySpread,
    this.ctaLabelBuilder,
  });

  final String id;
  final IconData icon;
  final String Function(String locale) titleBuilder;
  final String Function(String locale) descriptionBuilder;
  final List<String> recommendedSpreadIds;
  final String Function(String locale)? questionBuilder;
  final TarotSpread? primarySpread;
  final String Function(String locale)? ctaLabelBuilder;

  String ctaLabel(String locale) {
    return ctaLabelBuilder?.call(locale) ??
        _resolve(locale,
            en: 'Quick reading', es: 'Consulta rápida', ca: 'Consulta ràpida');
  }
}

final List<SpreadThemeOption> spreadThemes = [
  SpreadThemeOption(
    id: 'ai_auto',
    icon: Icons.auto_awesome,
    titleBuilder: (locale) => _resolve(locale,
        en: 'IA chooses for you',
        es: 'La IA elige por ti',
        ca: 'La IA tria per tu'),
    descriptionBuilder: (locale) => _resolve(locale,
        en: 'Tell the universe you are ready and receive the spread you most need.',
        es: 'Dile al universo que estás listo y recibe la tirada que más necesitas.',
        ca: 'Digues a l’univers que estàs preparat i rep la tirada que més necessites.'),
    recommendedSpreadIds: [
      'celtic_cross',
      'three_card',
      'star',
    ],
    questionBuilder: (locale) => _resolve(locale,
        en: 'General reading: what do I most need to understand right now?',
        es: 'Consulta general: ¿qué necesito saber ahora mismo para avanzar?',
        ca: 'Consulta general: què necessito saber ara mateix per avançar?'),
  ),
  SpreadThemeOption(
    id: 'love',
    icon: Icons.favorite,
    titleBuilder: (locale) => _resolve(locale,
        en: 'Love & relationships',
        es: 'Amor y relaciones',
        ca: 'Amor i relacions'),
    descriptionBuilder: (locale) => _resolve(locale,
        en: 'Explore bonds, chemistry and the lessons two souls share.',
        es: 'Explora vínculos, química y lescciones que comparten dos almas.',
        ca: 'Explora vincles, química i les lliçons que comparteixen dues ànimes.'),
    recommendedSpreadIds: [
      'relationship',
      'three_card',
      'horseshoe',
    ],
    questionBuilder: (locale) => _resolve(locale,
        en: 'What energy surrounds my heart and how can I invite more harmony?',
        es: '¿Qué energía rodea mi corazón y cómo puedo invitar más armonía?',
        ca: 'Quina energia envolta el meu cor i com puc convidar més harmonia?'),
  ),
  SpreadThemeOption(
    id: 'career',
    icon: Icons.work,
    titleBuilder: (locale) => _resolve(locale,
        en: 'Career & purpose',
        es: 'Carrera y propósito',
        ca: 'Carrera i propòsit'),
    descriptionBuilder: (locale) => _resolve(locale,
        en: 'Clarify decisions, leaps of faith and long-term paths.',
        es: 'Aclara decisiones, salts de fe y caminos a largo plazo.',
        ca: 'Aclareix decisions, salts de fe i camins a llarg termini.'),
    recommendedSpreadIds: [
      'pyramid',
      'five_card_cross',
      'celtic_cross',
    ],
    questionBuilder: (locale) => _resolve(locale,
        en: 'What professional direction aligns with my true calling?',
        es: '¿Qué dirección profesional se alinea con mi verdadera vocación?',
        ca: 'Quina direcció professional s’alinea amb la meva veritable vocació?'),
  ),
  SpreadThemeOption(
    id: 'money',
    icon: Icons.attach_money,
    titleBuilder: (locale) => _resolve(locale,
        en: 'Money & abundance',
        es: 'Dinero y abundancia',
        ca: 'Diners i abundància'),
    descriptionBuilder: (locale) => _resolve(locale,
        en: 'Understand flows, blockages and new opportunities.',
        es: 'Comprende flujos, bloqueos y nuevas oportunidades.',
        ca: 'Entén fluxos, bloquejos i noves oportunitats.'),
    recommendedSpreadIds: [
      'three_card',
      'horseshoe',
      'astrological',
    ],
    questionBuilder: (locale) => _resolve(locale,
        en: 'How can I create more stability and prosperity now?',
        es: '¿Cómo puedo crear más estabilidad y prosperidad ahora?',
        ca: 'Com puc crear més estabilitat i prosperitat ara?'),
  ),
  SpreadThemeOption(
    id: 'wellbeing',
    icon: Icons.self_improvement,
    titleBuilder: (locale) => _resolve(locale,
        en: 'Wellbeing & energy',
        es: 'Bienestar y energía',
        ca: 'Benestar i energia'),
    descriptionBuilder: (locale) => _resolve(locale,
        en: 'Listen to your body, intuition and daily rituals.',
        es: 'Escucha tu cuerpo, intuición y ritmos diarios.',
        ca: 'Escolta el teu cos, la intuïció i els ritmes diaris.'),
    recommendedSpreadIds: [
      'star',
      'single',
      'two_card',
    ],
    questionBuilder: (locale) => _resolve(locale,
        en: 'What do I need to nurture to feel balanced again?',
        es: '¿Qué necesito cuidar para sentirme en equilibrio de nuevo?',
        ca: 'Què necessito nodrir per tornar a sentir-me en equilibri?'),
  ),
  SpreadThemeOption(
    id: 'spiritual',
    icon: Icons.auto_graph,
    titleBuilder: (locale) => _resolve(locale,
        en: 'Spiritual growth',
        es: 'Crecimiento espiritual',
        ca: 'Creixement espiritual'),
    descriptionBuilder: (locale) => _resolve(locale,
        en: 'Connect with lessons, guides and inner wisdom.',
        es: 'Conecta con lecciones, guías y saviesa interior.',
        ca: 'Connecta amb lliçons, guies i saviesa interna.'),
    recommendedSpreadIds: [
      'star',
      'astrological',
      'year_ahead',
    ],
    questionBuilder: (locale) => _resolve(locale,
        en: 'What is the universe inviting me to learn right now?',
        es: '¿Qué me invita a aprender el universo ahora mismo?',
        ca: 'Què m’està convidant a aprendre l’univers ara mateix?'),
  ),
];

class _PageIndicator extends StatefulWidget {
  const _PageIndicator({
    required this.length,
    required this.controller,
  });

  final int length;
  final PageController controller;

  @override
  State<_PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {
      _currentPage = widget.controller.page ?? widget.controller.initialPage.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        final isActive = (index - _currentPage).abs() < 0.5;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? TarotTheme.cosmicAccent : TarotTheme.cosmicAccentSubtle,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

String _resolve(
  String locale, {
  required String en,
  required String es,
  required String ca,
}) {
  final language = locale.split(RegExp('[_-]')).first.toLowerCase();
  switch (language) {
    case 'ca':
      return ca;
    case 'es':
      return es;
    default:
      return en;
  }
}
