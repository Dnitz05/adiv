import 'dart:async';
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
  late AnimationController _pulseController;
  late Animation<Offset> _bannerAnimation;
  late Animation<double> _pulseAnimation;

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

    // Logo pulse animation (fade in/out)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _bannerController.forward();
    _pulseController.repeat(reverse: true);

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
    _pulseController.dispose();
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
            // Starry overlay
            Container(
              decoration: BoxDecoration(
                gradient: TarotTheme.starryOverlay,
              ),
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

            // Pulsing logo on top
            Center(
              child: FadeTransition(
                opacity: _pulseAnimation,
                child: Image.asset(
                  'assets/app_icon/icon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
