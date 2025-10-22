import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../models/tarot_card.dart';
import '../models/tarot_spread.dart';
import '../theme/tarot_theme.dart';
import 'spread_layout.dart';
import '../state/full_screen_step.dart';

String _t(
  CommonStrings localisation, {
  required String en,
  required String es,
  required String ca,
}) {
  final language =
      localisation.localeName.split(RegExp('[_-]')).first.toLowerCase();
  switch (language) {
    case 'ca':
      return ca;
    case 'es':
      return es;
    default:
      return en;
  }
}

class DrawFullScreenFlow extends StatelessWidget {
  const DrawFullScreenFlow({
    super.key,
    required this.step,
    required this.question,
    required this.recommendation,
    this.interpretationGuide,
    required this.spread,
    required this.cards,
    required this.dealtCardCount,
    required this.dealingCards,
    required this.revealedCardCount,
    required this.revealingCards,
    required this.requestingInterpretation,
    required this.interpretationAvailable,
    required this.interpretationContent,
    required this.localisation,
    required this.onClose,
    required this.onStartDealing,
    required this.onDeal,
    required this.onReveal,
    required this.onInterpret,
    required this.onShowInterpretation,
  });

  final FullScreenStep step;
  final String question;
  final String? recommendation;
  final String? interpretationGuide;
  final TarotSpread spread;
  final List<TarotCard> cards;
  final int dealtCardCount;
  final bool dealingCards;
  final int revealedCardCount;
  final bool revealingCards;
  final bool requestingInterpretation;
  final bool interpretationAvailable;
  final Widget? interpretationContent;
  final CommonStrings localisation;
  final VoidCallback onClose;
  final Future<void> Function() onStartDealing;
  final Future<void> Function() onDeal;
  final Future<void> Function() onReveal;
  final Future<void> Function() onInterpret;
  final VoidCallback onShowInterpretation;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (step) {
      case FullScreenStep.spreadPresentation:
        content = _SpreadPresentationStep(
          key: const ValueKey('presentation'),
          question: question,
          recommendation: recommendation,
          interpretationGuide: interpretationGuide,
          spread: spread,
          localisation: localisation,
          onClose: onClose,
          onStartDealing: onStartDealing,
        );
        break;
      case FullScreenStep.dealing:
        content = _DealingStep(
          key: const ValueKey('dealing'),
          spread: spread,
          cards: cards,
          dealtCardCount: dealtCardCount,
          dealingCards: dealingCards,
          localisation: localisation,
          onClose: onClose,
          onReveal: onReveal,
        );
        break;
      case FullScreenStep.revealed:
        content = _RevealedStep(
          key: const ValueKey('revealed'),
          spread: spread,
          cards: cards,
          localisation: localisation,
          onClose: onClose,
          onShowInterpretation: onShowInterpretation,
        );
        break;
      case FullScreenStep.interpretation:
        content = _InterpretationStep(
          key: const ValueKey('interpretation'),
          interpretationContent: interpretationContent,
          localisation: localisation,
          onClose: onClose,
        );
        break;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Material(
        color: TarotTheme.deepNightOverlay,
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: content,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STEP 1: SPREAD PRESENTATION (Diagram + AI Reasoning)
// ============================================================================

class _SpreadPresentationStep extends StatelessWidget {
  const _SpreadPresentationStep({
    super.key,
    required this.question,
    required this.recommendation,
    this.interpretationGuide,
    required this.spread,
    required this.localisation,
    required this.onClose,
    required this.onStartDealing,
  });

  final String question;
  final String? recommendation;
  final String? interpretationGuide;
  final TarotSpread spread;
  final CommonStrings localisation;
  final VoidCallback onClose;
  final Future<void> Function() onStartDealing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header section - single line
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: _t(
                    localisation,
                    en: 'Selected Spread: ',
                    es: 'Tirada Escogida: ',
                    ca: 'Tirada Escollida: ',
                  ),
                  style: const TextStyle(
                    color: TarotTheme.cosmicBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                TextSpan(
                  text: spread.localizedName(localisation.localeName),
                  style: const TextStyle(
                    color: TarotTheme.cosmicAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Spread diagram (fixed proportion)
        Expanded(
          flex: 55,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SpreadLayout(
                  spread: spread,
                  cards: const [], // Empty = show placeholders
                  maxWidth: constraints.maxWidth > 0
                      ? constraints.maxWidth
                      : MediaQuery.of(context).size.width - 32,
                  maxHeight: constraints.maxHeight,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // AI Reasoning section (fixed proportion, scrollable internally if needed)
        Expanded(
          flex: 25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: recommendation != null && recommendation!.isNotEmpty
                  ? _InfoPanel(
                      icon: Icons.psychology_outlined,
                      title: _t(
                        localisation,
                        en: 'Why this spread?',
                        es: '¿Por qué esta tirada?',
                        ca: 'Per què aquesta tirada?',
                      ),
                      body: recommendation!,
                    )
                  : _InfoPanel(
                      icon: Icons.info_outline,
                      title: spread.localizedName(localisation.localeName),
                      body: spread.localizedDescription(localisation.localeName),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Sticky footer button
        Padding(
          padding: const EdgeInsets.all(16),
          child: _PrimaryButton(
            label: _t(
              localisation,
              en: 'Deal Cards',
              es: 'Repartir Cartas',
              ca: 'Repartir Cartes',
            ),
            onPressed: onStartDealing,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// STEP 2: DEALING (Card by card animation)
// ============================================================================

class _DealingStep extends StatelessWidget {
  const _DealingStep({
    super.key,
    required this.spread,
    required this.cards,
    required this.dealtCardCount,
    required this.dealingCards,
    required this.localisation,
    required this.onClose,
    required this.onReveal,
  });

  final TarotSpread spread;
  final List<TarotCard> cards;
  final int dealtCardCount;
  final bool dealingCards;
  final CommonStrings localisation;
  final VoidCallback onClose;
  final Future<void> Function() onReveal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show cards dealt so far (face down)
                      SpreadLayout(
                        spread: spread,
                        cards: cards.take(dealtCardCount).toList(),
                        maxWidth: constraints.maxWidth > 0
                            ? constraints.maxWidth
                            : MediaQuery.of(context).size.width - 32,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        revealedCardCount: 0, // All face down during dealing
                      ),

                      const SizedBox(height: 32),

                      // Dealing indicator
                      if (dealingCards) ...[
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            TarotTheme.cosmicAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _t(
                            localisation,
                            en: 'Dealing cards...',
                            es: 'Repartiendo cartas...',
                            ca: 'Repartint cartes...',
                          ),
                          style: TextStyle(
                            color: TarotTheme.stardust,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // Reveal button - only show when dealing is complete
        if (!dealingCards)
          Padding(
            padding: const EdgeInsets.all(16),
            child: _PrimaryButton(
              label: _t(
                localisation,
                en: 'Reveal Cards',
                es: 'Revelar Cartas',
                ca: 'Revelar Cartes',
              ),
              onPressed: onReveal,
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// STEP 3: REVEALED (All cards face up)
// ============================================================================

class _RevealedStep extends StatelessWidget {
  const _RevealedStep({
    super.key,
    required this.spread,
    required this.cards,
    required this.localisation,
    required this.onClose,
    required this.onShowInterpretation,
  });

  final TarotSpread spread;
  final List<TarotCard> cards;
  final CommonStrings localisation;
  final VoidCallback onClose;
  final VoidCallback onShowInterpretation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    // All cards revealed
                    SpreadLayout(
                      spread: spread,
                      cards: cards,
                      maxWidth: constraints.maxWidth > 0
                          ? constraints.maxWidth
                          : MediaQuery.of(context).size.width - 32,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      revealedCardCount: cards.length, // All revealed
                    ),

                    const SizedBox(height: 32),

                    Text(
                      _t(
                        localisation,
                        en: 'Your cards have been revealed',
                        es: 'Tus cartas han sido reveladas',
                        ca: 'Les teves cartes han estat revelades',
                      ),
                      style: TextStyle(
                        color: TarotTheme.moonlight,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Button to see interpretation
        Padding(
          padding: const EdgeInsets.all(16),
          child: _PrimaryButton(
            label: _t(
              localisation,
              en: 'See Interpretation',
              es: 'Ver Interpretación',
              ca: 'Veure Interpretació',
            ),
            onPressed: onShowInterpretation,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// STEP 4: INTERPRETATION (Full AI reading)
// ============================================================================

class _InterpretationStep extends StatelessWidget {
  const _InterpretationStep({
    super.key,
    required this.interpretationContent,
    required this.localisation,
    required this.onClose,
  });

  final Widget? interpretationContent;
  final CommonStrings localisation;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                interpretationContent ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),

        // Back to chat button
        Padding(
          padding: const EdgeInsets.all(16),
          child: _PrimaryButton(
            label: _t(
              localisation,
              en: 'Back to Chat',
              es: 'Volver al Chat',
              ca: 'Torna al Xat',
            ),
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SHARED WIDGETS
// ============================================================================

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TarotTheme.midnightBlueTransparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TarotTheme.cosmicAccentSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: TarotTheme.cosmicAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: TarotTheme.cosmicAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBodyWithColoredBullets(body),
        ],
      ),
    );
  }

  Widget _buildBodyWithColoredBullets(String body) {
    final parts = body.split('•');
    if (parts.length == 1) {
      // No bullets, just regular text
      return Text(
        body,
        style: const TextStyle(
          color: TarotTheme.moonlight,
          fontSize: 15,
          height: 1.6,
        ),
      );
    }

    // Has bullets
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: TarotTheme.moonlight,
          fontSize: 15,
          height: 1.6,
        ),
        children: [
          TextSpan(text: parts[0]), // Intro text
          for (int i = 1; i < parts.length; i++) ...[
            const TextSpan(
              text: '•',
              style: TextStyle(
                color: TarotTheme.cosmicAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: parts[i]),
          ],
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TarotTheme.cosmicAccent,
          foregroundColor: TarotTheme.deepNight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

