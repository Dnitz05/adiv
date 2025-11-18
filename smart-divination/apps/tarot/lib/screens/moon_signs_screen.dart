import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../models/moon_sign.dart';
import '../data/moon_signs_data.dart';
import '../theme/tarot_theme.dart';
import 'moon_sign_detail_screen.dart';

/// Main screen for Moon in Signs - The 12 zodiac signs
/// Shows how the Moon expresses emotions in each sign
class MoonSignsScreen extends StatelessWidget {
  final CommonStrings? strings;

  const MoonSignsScreen({super.key, this.strings});

  String _getLocale() {
    return strings?.localeName ?? 'en';
  }

  String _getScreenTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lluna en els Signes';
      case 'es':
        return 'Luna en los Signos';
      default:
        return 'Moon in Signs';
    }
  }

  String _getZodiacSignsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Els 12 Signes Zodiacals';
      case 'es':
        return 'Los 12 Signos Zodiacales';
      default:
        return 'The 12 Zodiac Signs';
    }
  }

  String _getYourSunSignLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'El teu signe solar:';
      case 'es':
        return 'Tu signo solar:';
      default:
        return 'Your sun sign:';
    }
  }

  String _getWelcomeTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Lluna en els Signes';
      case 'es':
        return 'Luna en los Signos';
      default:
        return 'Moon in the Signs';
    }
  }

  String _getWelcomeSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Els 12 signes zodiacals i la influència lunar';
      case 'es':
        return 'Los 12 signos zodiacales y la influencia lunar';
      default:
        return 'The 12 zodiac signs and lunar influence';
    }
  }

  String _getWelcomeDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Quan la Lluna passa per cada signe del zodíac, les nostres emocions s\'expressen de forma diferent. Cada signe porta el seu propi estil emocional, des de l\'ardor d\'Àries fins a la compassió de Peixos. Descobreix com cada signe influeix en el teu món interior.';
      case 'es':
        return 'Cuando la Luna pasa por cada signo del zodíaco, nuestras emociones se expresan de forma diferente. Cada signo aporta su propio estilo emocional, desde el ardor de Aries hasta la compasión de Piscis. Descubre cómo cada signo influye en tu mundo interior.';
      default:
        return 'When the Moon passes through each zodiac sign, our emotions express themselves differently. Each sign brings its own emotional style, from the fire of Aries to the compassion of Pisces. Discover how each sign influences your inner world.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();
    final currentSunSign = MoonSignsData.getCurrentSunSign();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(_getScreenTitle(locale)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeCard(
              locale: locale,
              title: _getWelcomeTitle(locale),
              subtitle: _getWelcomeSubtitle(locale),
              description: _getWelcomeDescription(locale),
            ),
            const SizedBox(height: 24),
            if (currentSunSign != null) ...[
              _CurrentSignCard(sign: currentSunSign, locale: locale, label: _getYourSunSignLabel(locale)),
              const SizedBox(height: 24),
            ],
            Text(
              _getZodiacSignsTitle(locale),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            _SignsGrid(locale: locale),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String locale;
  final String title;
  final String subtitle;
  final String description;

  const _WelcomeCard({
    required this.locale,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TarotTheme.cosmicAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '♈',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _CurrentSignCard extends StatelessWidget {
  final MoonSign sign;
  final String locale;
  final String label;

  const _CurrentSignCard({
    required this.sign,
    required this.locale,
    required this.label,
  });

  Color _getSignColor() {
    return Color(int.parse(sign.color.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final signColor = _getSignColor();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            signColor,
            signColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: signColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                sign.icon,
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.getLocalizedName(locale),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sign.getArchetype(locale),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignsGrid extends StatelessWidget {
  final String locale;

  const _SignsGrid({required this.locale});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: MoonSignsData.signs.length,
      itemBuilder: (context, index) {
        final sign = MoonSignsData.signs[index];
        return _SignGridCard(sign: sign, locale: locale);
      },
    );
  }
}

class _SignGridCard extends StatelessWidget {
  final MoonSign sign;
  final String locale;

  const _SignGridCard({
    required this.sign,
    required this.locale,
  });

  Color _getSignColor() {
    return Color(int.parse(sign.color.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final signColor = _getSignColor();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoonSignDetailScreen(sign: sign),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: signColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: signColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: Text(
                  sign.icon,
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sign.getLocalizedName(locale),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              sign.symbol,
              style: TextStyle(
                fontSize: 20,
                color: signColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: signColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                sign.element,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: signColor.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
