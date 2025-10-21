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
    required this.onBriefingContinue,
    required this.onDeal,
    required this.onReveal,
    required this.onInterpret,
    required this.onShowInterpretation,
  });

  final FullScreenStep step;
  final String question;
  final String? recommendation;
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
  final VoidCallback onBriefingContinue;
  final Future<void> Function() onDeal;
  final Future<void> Function() onReveal;
  final Future<void> Function() onInterpret;
  final VoidCallback onShowInterpretation;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (step) {
      case FullScreenStep.briefing:
        content = _BriefingStep(
          key: const ValueKey('briefing'),
          question: question,
          recommendation: recommendation,
          spread: spread,
          localisation: localisation,
          onClose: onClose,
          onContinue: onBriefingContinue,
        );
        break;
      case FullScreenStep.spread:
        content = _SpreadStep(
          key: const ValueKey('spread'),
          question: question,
          recommendation: recommendation,
          spread: spread,
          cards: cards,
          dealtCardCount: dealtCardCount,
          dealingCards: dealingCards,
          revealedCardCount: revealedCardCount,
          revealingCards: revealingCards,
          requestingInterpretation: requestingInterpretation,
          interpretationAvailable: interpretationAvailable,
          localisation: localisation,
          onClose: onClose,
          onDeal: onDeal,
          onReveal: onReveal,
          onInterpret: onInterpret,
          onShowInterpretation: onShowInterpretation,
        );
        break;
      case FullScreenStep.interpretation:
        content = _InterpretationStep(
          key: const ValueKey('interpretation'),
          question: question,
          spread: spread,
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

class _BriefingStep extends StatelessWidget {
  const _BriefingStep({
    super.key,
    required this.question,
    required this.recommendation,
    required this.spread,
    required this.localisation,
    required this.onClose,
    required this.onContinue,
  });

  final String question;
  final String? recommendation;
  final TarotSpread spread;
  final CommonStrings localisation;
  final VoidCallback onClose;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(onClose: onClose, title: localisation.appTitleTarot),
          const SizedBox(height: 24),
          Text(
            _t(
              localisation,
              en: 'Prepare the reading',
              es: 'Prepara la tirada',
              ca: 'Prepara la tirada',
            ),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: TarotTheme.moonlight,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          _InfoPanel(
            icon: Icons.help_outline,
            title: _t(
              localisation,
              en: 'Your question',
              es: 'Tu pregunta',
              ca: 'La teva pregunta',
            ),
            body: question,
          ),
          const SizedBox(height: 16),
          _InfoPanel(
            icon: Icons.style_outlined,
            title: _t(
              localisation,
              en: 'Why this spread?',
              es: '¿Por qué esta tirada?',
              ca: 'Per què aquesta tirada?',
            ),
            body: recommendation ??
                spread.localizedDescription(localisation.localeName),
          ),
          const Spacer(),
          _PrimaryButton(
            label: _t(
              localisation,
              en: 'Start the spread',
              es: 'Iniciar la tirada',
              ca: 'Començar la tirada',
            ),
            onPressed: onContinue,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SpreadStep extends StatelessWidget {
  const _SpreadStep({
    super.key,
    required this.question,
    required this.recommendation,
    required this.spread,
    required this.cards,
    required this.dealtCardCount,
    required this.dealingCards,
    required this.revealedCardCount,
    required this.revealingCards,
    required this.requestingInterpretation,
    required this.interpretationAvailable,
    required this.localisation,
    required this.onClose,
    required this.onDeal,
    required this.onReveal,
    required this.onInterpret,
    required this.onShowInterpretation,
  });

  final String question;
  final String? recommendation;
  final TarotSpread spread;
  final List<TarotCard> cards;
  final int dealtCardCount;
  final bool dealingCards;
  final int revealedCardCount;
  final bool revealingCards;
  final bool requestingInterpretation;
  final bool interpretationAvailable;
  final CommonStrings localisation;
  final VoidCallback onClose;
  final Future<void> Function() onDeal;
  final Future<void> Function() onReveal;
  final Future<void> Function() onInterpret;
  final VoidCallback onShowInterpretation;

  @override
  Widget build(BuildContext context) {
    final totalCards = cards.length;
    final bool allDealt = dealtCardCount >= totalCards;
    final bool allRevealed = revealedCardCount >= totalCards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _TopBar(
              onClose: onClose,
              title: spread.localizedName(localisation.localeName)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _InfoPanel(
            icon: Icons.help_outline,
            title: _t(
              localisation,
              en: 'Your question',
              es: 'Tu pregunta',
              ca: 'La teva pregunta',
            ),
            body: question,
          ),
        ),
        if (recommendation != null) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _InfoPanel(
              icon: Icons.psychology_alt_outlined,
              title: _t(
                localisation,
                en: 'Why this spread?',
                es: '¿Por qué esta tirada?',
                ca: 'Per què aquesta tirada?',
              ),
              body: recommendation!,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SpreadLayout(
                  spread: spread,
                  cards: cards,
                  maxWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                  dealtCardCount: dealtCardCount,
                  revealedCardCount: revealedCardCount,
                  locale: localisation.localeName,
                );
              },
            ),
          ),
        ),
        _SpreadFooter(
          allDealt: allDealt,
          allRevealed: allRevealed,
          dealingCards: dealingCards,
          revealingCards: revealingCards,
          requestingInterpretation: requestingInterpretation,
          interpretationAvailable: interpretationAvailable,
          localisation: localisation,
          onDeal: onDeal,
          onReveal: onReveal,
          onInterpret: onInterpret,
          onShowInterpretation: onShowInterpretation,
        ),
      ],
    );
  }
}

class _InterpretationStep extends StatelessWidget {
  const _InterpretationStep({
    super.key,
    required this.question,
    required this.spread,
    required this.interpretationContent,
    required this.localisation,
    required this.onClose,
  });

  final String question;
  final TarotSpread spread;
  final Widget? interpretationContent;
  final CommonStrings localisation;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(
            onClose: onClose,
            title: _t(
              localisation,
              en: 'Interpretation',
              es: 'Interpretación',
              ca: 'Interpretació',
            ),
          ),
          const SizedBox(height: 20),
          _InfoPanel(
            icon: Icons.help_outline,
            title: _t(
              localisation,
              en: 'Your question',
              es: 'Tu pregunta',
              ca: 'La teva pregunta',
            ),
            body: question,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: interpretationContent != null
                ? SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: interpretationContent!,
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(
                          _t(
                            localisation,
                            en: 'Loading interpretation...',
                            es: 'Cargando interpretación...',
                            ca: 'Carregant interpretació...',
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: TarotTheme.moonlight),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
          _PrimaryButton(
            label: _t(
              localisation,
              en: 'Back to chat',
              es: 'Volver al chat',
              ca: 'Torna al xat',
            ),
            onPressed: onClose,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({super.key, required this.onClose, required this.title});

  final VoidCallback onClose;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: TarotTheme.moonlight),
        ),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TarotTheme.moonlight,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    super.key,
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
              Icon(icon, color: TarotTheme.cosmicAccent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: TarotTheme.cosmicAccent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: TarotTheme.moonlight, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: TarotTheme.cosmicAccent,
          foregroundColor: TarotTheme.moonlight,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

class _SpreadFooter extends StatelessWidget {
  const _SpreadFooter({
    required this.allDealt,
    required this.allRevealed,
    required this.dealingCards,
    required this.revealingCards,
    required this.requestingInterpretation,
    required this.interpretationAvailable,
    required this.localisation,
    required this.onDeal,
    required this.onReveal,
    required this.onInterpret,
    required this.onShowInterpretation,
  });

  final bool allDealt;
  final bool allRevealed;
  final bool dealingCards;
  final bool revealingCards;
  final bool requestingInterpretation;
  final bool interpretationAvailable;
  final CommonStrings localisation;
  final Future<void> Function() onDeal;
  final Future<void> Function() onReveal;
  final Future<void> Function() onInterpret;
  final VoidCallback onShowInterpretation;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (dealingCards || revealingCards) {
      child = const _FooterProgress();
    } else if (!allDealt) {
      child = _PrimaryButton(
        label: _t(
          localisation,
          en: 'Deal cards',
          es: 'Repartir cartas',
          ca: 'Repartir cartes',
        ),
        onPressed: () => onDeal(),
      );
    } else if (!allRevealed) {
      child = _PrimaryButton(
        label: _t(
          localisation,
          en: 'Reveal cards',
          es: 'Revelar cartas',
          ca: 'Revelar cartes',
        ),
        onPressed: () => onReveal(),
      );
    } else if (requestingInterpretation) {
      child = const _FooterProgress();
    } else if (interpretationAvailable) {
      child = _PrimaryButton(
        label: _t(
          localisation,
          en: 'View interpretation',
          es: 'Ver interpretación',
          ca: 'Veure interpretació',
        ),
        onPressed: onShowInterpretation,
      );
    } else {
      child = _PrimaryButton(
        label: _t(
          localisation,
          en: 'Interpret the spread',
          es: 'Interpretar la tirada',
          ca: 'Interpretar la tirada',
        ),
        onPressed: () => onInterpret(),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: child,
    );
  }
}

class _FooterProgress extends StatelessWidget {
  const _FooterProgress();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
