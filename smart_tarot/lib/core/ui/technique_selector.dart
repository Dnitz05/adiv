import 'package:flutter/material.dart';
import '../../shared/models/contracts.dart';

class TechniqueSelector extends StatefulWidget {
  final Function(DivinationTechnique) onTechniqueSelected;
  final String locale;

  const TechniqueSelector({
    super.key,
    required this.onTechniqueSelected,
    required this.locale,
  });

  @override
  State<TechniqueSelector> createState() => _TechniqueSelectorState();
}

class _TechniqueSelectorState extends State<TechniqueSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              children: [
                Text(
                  _getWelcomeText(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getSubtitleText(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildTechniqueCards(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTechniqueCards() {
    return Column(
      children: [
        _buildTechniqueCard(
          technique: DivinationTechnique.tarot,
          icon: '🃏',
          title: _getTechniqueTitle(DivinationTechnique.tarot),
          subtitle: _getTechniqueSubtitle(DivinationTechnique.tarot),
          color: const Color(0xFF4C1D95),
          delay: 0,
        ),
        const SizedBox(height: 12),
        _buildTechniqueCard(
          technique: DivinationTechnique.iching,
          icon: '☯️',
          title: _getTechniqueTitle(DivinationTechnique.iching),
          subtitle: _getTechniqueSubtitle(DivinationTechnique.iching),
          color: const Color(0xFFDC2626),
          delay: 100,
        ),
        const SizedBox(height: 12),
        _buildTechniqueCard(
          technique: DivinationTechnique.runes,
          icon: 'ᚱ',
          title: _getTechniqueTitle(DivinationTechnique.runes),
          subtitle: _getTechniqueSubtitle(DivinationTechnique.runes),
          color: const Color(0xFF059669),
          delay: 200,
        ),
      ],
    );
  }

  Widget _buildTechniqueCard({
    required DivinationTechnique technique,
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _selectTechnique(technique, color),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectTechnique(DivinationTechnique technique, Color color) {
    // Add haptic feedback
    // HapticFeedback.selectionClick(); // Uncomment when available
    
    // Animate selection
    _animationController.reverse().then((_) {
      widget.onTechniqueSelected(technique);
    });
  }

  String _getWelcomeText() {
    const messages = {
      'ca': '🔮 Benvingut/da!',
      'es': '🔮 ¡Bienvenido/a!',
      'en': '🔮 Welcome!',
    };
    return messages[widget.locale] ?? messages['en']!;
  }

  String _getSubtitleText() {
    const messages = {
      'ca': 'Quina tècnica t\'agradaria explorar avui?',
      'es': '¿Qué técnica te gustaría explorar hoy?',
      'en': 'Which technique would you like to explore today?',
    };
    return messages[widget.locale] ?? messages['en']!;
  }

  String _getTechniqueTitle(DivinationTechnique technique) {
    const titles = {
      'tarot': {
        'ca': 'Tarot',
        'es': 'Tarot',
        'en': 'Tarot',
      },
      'iching': {
        'ca': 'I Ching',
        'es': 'I Ching',
        'en': 'I Ching',
      },
      'runes': {
        'ca': 'Runes',
        'es': 'Runas',
        'en': 'Runes',
      },
    };
    return titles[technique.name]?[widget.locale] ?? titles[technique.name]?['en'] ?? '';
  }

  String _getTechniqueSubtitle(DivinationTechnique technique) {
    const subtitles = {
      'tarot': {
        'ca': 'Cartes per a orientació i reflexió',
        'es': 'Cartas para orientación y reflexión',
        'en': 'Cards for guidance and reflection',
      },
      'iching': {
        'ca': 'Saviesa ancestral xinesa',
        'es': 'Sabiduría ancestral china',
        'en': 'Ancient Chinese wisdom',
      },
      'runes': {
        'ca': 'Símbols nòrdics de poder',
        'es': 'Símbolos nórdicos de poder',
        'en': 'Nordic symbols of power',
      },
    };
    return subtitles[technique.name]?[widget.locale] ?? subtitles[technique.name]?['en'] ?? '';
  }
}