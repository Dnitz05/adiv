import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/models/contracts.dart';

class DivinationResultWidget extends StatefulWidget {
  final DivinationTechnique technique;
  final Map<String, dynamic> toolResult;
  final String seed;
  final Function(String) onReplay;

  const DivinationResultWidget({
    super.key,
    required this.technique,
    required this.toolResult,
    required this.seed,
    required this.onReplay,
  });

  @override
  State<DivinationResultWidget> createState() => _DivinationResultWidgetState();
}

class _DivinationResultWidgetState extends State<DivinationResultWidget>
    with TickerProviderStateMixin {
  late AnimationController _revealController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeIn,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    ));

    _revealController.forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _revealController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        _getTechniqueColor().withOpacity(0.1),
                        _getTechniqueColor().withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildResultContent(),
                      const SizedBox(height: 16),
                      _buildActions(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTechniqueColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getTechniqueIcon(),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTechniqueName(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getTechniqueColor(),
                ),
              ),
              Text(
                'Result obtained',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + 0.1 * (0.5 + 0.5 * _pulseController.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultContent() {
    switch (widget.technique) {
      case DivinationTechnique.tarot:
        return _buildTarotResult();
      case DivinationTechnique.iching:
        return _buildIChingResult();
      case DivinationTechnique.runes:
        return _buildRunesResult();
    }
  }

  Widget _buildTarotResult() {
    final cards = widget.toolResult['result'] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cards Drawn:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cards.map<Widget>((card) {
            final isUpright = card['upright'] as bool;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getTechniqueColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getTechniqueColor().withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card['id'].toString().replaceAll('_', ' '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isUpright ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 16,
                    color: isUpright ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIChingResult() {
    final result = widget.toolResult['result'];
    final lines = List<int>.from(result['lines']);
    final changingLines = List<int>.from(result['changing_lines']);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hexagram ${result['primary_hex']}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getTechniqueColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: lines.asMap().entries.map((entry) {
              final index = entry.key;
              final line = entry.value;
              final isChanging = changingLines.contains(index + 1);
              final isYang = line % 2 == 1;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text('${6 - index}:', style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isYang ? _getTechniqueColor() : Colors.transparent,
                        border: isYang ? null : Border.all(color: _getTechniqueColor()),
                      ),
                    ),
                    if (isChanging) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.autorenew,
                        size: 12,
                        color: _getTechniqueColor(),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        if (changingLines.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Result: Hexagram ${result['result_hex']}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: _getTechniqueColor(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRunesResult() {
    final runes = widget.toolResult['result'] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Runes Drawn:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: runes.map<Widget>((rune) {
            final isUpright = rune['upright'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTechniqueColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getTechniqueColor().withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTechniqueColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'ᚱ', // Placeholder rune symbol
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                          '${rune['id']} (${rune['slot']})',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          isUpright ? 'Upright' : 'Reversed',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isUpright ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showSeedDialog(),
            icon: const Icon(Icons.info_outline, size: 16),
            label: const Text('Seed Info'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _getTechniqueColor(),
              side: BorderSide(color: _getTechniqueColor()),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => widget.onReplay(widget.seed),
            icon: const Icon(Icons.replay, size: 16),
            label: const Text('Replay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getTechniqueColor(),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showSeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randomness Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This result was generated using cryptographically secure randomness.'),
            const SizedBox(height: 16),
            Text(
              'Seed:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                widget.seed,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can use this seed to reproduce the exact same result.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.seed));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seed copied to clipboard')),
              );
            },
            child: const Text('Copy Seed'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getTechniqueColor() {
    switch (widget.technique) {
      case DivinationTechnique.tarot:
        return const Color(0xFF4C1D95);
      case DivinationTechnique.iching:
        return const Color(0xFFDC2626);
      case DivinationTechnique.runes:
        return const Color(0xFF059669);
    }
  }

  String _getTechniqueIcon() {
    switch (widget.technique) {
      case DivinationTechnique.tarot:
        return '🃏';
      case DivinationTechnique.iching:
        return '☯️';
      case DivinationTechnique.runes:
        return 'ᚱ';
    }
  }

  String _getTechniqueName() {
    switch (widget.technique) {
      case DivinationTechnique.tarot:
        return 'Tarot';
      case DivinationTechnique.iching:
        return 'I Ching';
      case DivinationTechnique.runes:
        return 'Runes';
    }
  }
}