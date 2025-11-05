import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated "typing..." indicator shown when AI is responding
///
/// Shows three bouncing dots in a grey bubble, similar to WhatsApp
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // AI Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.purple[300]!,
                  Colors.blue[300]!,
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          // Typing bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _BouncingDot(
                        animationValue: _controller.value,
                        index: index,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A single bouncing dot in the typing indicator
class _BouncingDot extends StatelessWidget {
  const _BouncingDot({
    required this.animationValue,
    required this.index,
  });

  final double animationValue;
  final int index;

  @override
  Widget build(BuildContext context) {
    // Offset each dot by 1/3 of the animation cycle
    final offset = (animationValue + index * 0.33) % 1.0;

    // Create a bouncing effect using sine wave
    final bounce = math.sin(offset * math.pi * 2);

    // Scale factor (0.5 to 1.0)
    final scale = 0.7 + (bounce.abs() * 0.3);

    // Opacity (0.3 to 1.0)
    final opacity = 0.3 + (bounce.abs() * 0.7);

    return Transform.translate(
      offset: Offset(0, -bounce * 4), // Vertical bounce
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[600]!.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }
}
