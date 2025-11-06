import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tarot_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _rotationController;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _readyToComplete = false;
  bool _firstFrameRendered = false;

  @override
  void initState() {
    super.initState();

    // Logo materialization animation (fade in + scale up from background)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Starry rotation animation (accelerating from center)
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi * 2, // Full rotation
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    _rotationController.repeat();

    // Wait for first frame to be rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstFrameRendered = true;
      _checkAndComplete();
    });

    // Safety timeout - complete after 1 second maximum
    Timer(const Duration(milliseconds: 1000), () {
      _readyToComplete = true;
      _checkAndComplete();
    });
  }

  void _checkAndComplete() {
    if (_readyToComplete && _firstFrameRendered && mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: TarotTheme.subtleBackgroundGradient,
        ),
        child: Stack(
          children: [
            // Rotating starry background
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: StarsPainter(),
                  ),
                );
              },
            ),

            // Materializing logo
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Image.asset(
                        'assets/branding/logo-icon.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for starry background
class StarsPainter extends CustomPainter {
  static final _random = math.Random(42); // Fixed seed for consistent stars
  static final List<Star> _stars = _generateStars();

  static List<Star> _generateStars() {
    final stars = <Star>[];
    for (int i = 0; i < 150; i++) {
      stars.add(Star(
        x: _random.nextDouble() * 2000 - 1000, // Spread across large area
        y: _random.nextDouble() * 2000 - 1000,
        size: _random.nextDouble() * 2.5 + 0.5,
        opacity: _random.nextDouble() * 0.7 + 0.3,
      ));
    }
    return stars;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (final star in _stars) {
      paint.color = TarotTheme.moonlight.withValues(alpha: star.opacity);
      canvas.drawCircle(
        Offset(centerX + star.x, centerY + star.y),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
  });
}
