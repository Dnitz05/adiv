import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import '../theme/tarot_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    required this.userId,
    this.locale,
  });

  final String userId;
  final String? locale;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarotTheme.skyBlueLight,
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: TarotTheme.deepNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TarotTheme.skyBlueLight,
              TarotTheme.lunarLavenderLight,
            ],
          ),
        ),
        child: SafeArea(
          child: widget.userId.isEmpty
              ? _buildEmptyState()
              : _buildHistoryContent(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    TarotTheme.cosmicPurple.withValues(alpha: 0.2),
                    TarotTheme.cosmicAccent.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: Icon(
                Icons.history,
                size: 64,
                color: TarotTheme.cosmicPurple.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getEmptyTitle(),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getEmptyDescription(),
              style: TextStyle(
                color: TarotTheme.softBlueGrey.withOpacity(0.8),
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    TarotTheme.cosmicPurple,
                    TarotTheme.cosmicAccent,
                  ],
                ),
              ),
              child: const Icon(
                Icons.history,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getComingSoonTitle(),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getComingSoonDescription(),
              style: TextStyle(
                color: TarotTheme.softBlueGrey.withOpacity(0.8),
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    final locale = widget.locale ?? 'en';
    switch (locale) {
      case 'es':
        return 'Historial';
      case 'ca':
        return 'Historial';
      default:
        return 'History';
    }
  }

  String _getEmptyTitle() {
    final locale = widget.locale ?? 'en';
    switch (locale) {
      case 'es':
        return 'Inicia sesión para ver tu historial';
      case 'ca':
        return 'Inicia sessió per veure el teu historial';
      default:
        return 'Sign in to view your history';
    }
  }

  String _getEmptyDescription() {
    final locale = widget.locale ?? 'en';
    switch (locale) {
      case 'es':
        return 'Aquí encontrarás todas tus lecturas y sesiones pasadas';
      case 'ca':
        return 'Aquí trobaràs totes les teves lectures i sessions anteriors';
      default:
        return 'Here you\'ll find all your past readings and sessions';
    }
  }

  String _getComingSoonTitle() {
    final locale = widget.locale ?? 'en';
    switch (locale) {
      case 'es':
        return 'Próximamente';
      case 'ca':
        return 'Properament';
      default:
        return 'Coming Soon';
    }
  }

  String _getComingSoonDescription() {
    final locale = widget.locale ?? 'en';
    switch (locale) {
      case 'es':
        return 'Pronto podrás revisar todas tus lecturas, sesiones y estadísticas de uso';
      case 'ca':
        return 'Aviat podràs revisar totes les teves lectures, sessions i estadístiques d\'ús';
      default:
        return 'Soon you\'ll be able to review all your readings, sessions and usage statistics';
    }
  }
}
