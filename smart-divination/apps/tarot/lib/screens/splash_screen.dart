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
  late AnimationController _bannerController;
  late AnimationController _logoController;
  late AnimationController _rotationController;
  late Animation<Offset> _bannerAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Banner slide animation (left to right)
    _bannerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bannerAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeOut,
    ));

    // Logo materialization animation (fade in + scale up from background)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
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
    _bannerController.forward();
    _logoController.forward();
    _rotationController.repeat();

    // Complete splash after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
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

            // Banner sliding from left to right
            Align(
              alignment: Alignment.center,
              child: SlideTransition(
                position: _bannerAnimation,
                child: Image.asset(
                  'assets/banner.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to home_banner if banner.png doesn't exist
                    return Image.asset(
                      'assets/home_banner.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),

            // Materializing logo on top (larger size)
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Image.asset(
                        'assets/app_icon/icon.png',
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
      paint.color = TarotTheme.moonlight.withOpacity(star.opacity);
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
