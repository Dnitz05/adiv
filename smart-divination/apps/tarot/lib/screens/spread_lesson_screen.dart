import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chat_message.dart';
import '../models/spread_basic_info.dart';
import '../theme/tarot_theme.dart';
import '../services/learn_progress_service.dart';
import '../services/spread_recommendation_service.dart';
import '../widgets/spread_educational_panel.dart';

/// Individual spread lesson screen with complete educational content
///
/// This screen fetches and displays comprehensive educational content
/// for a specific spread, including:
/// - Purpose, when to use, when to avoid
/// - Interpretation method
/// - Position interactions
/// - Practice button to try the spread
class SpreadLessonScreen extends StatefulWidget {
  const SpreadLessonScreen({
    super.key,
    required this.spreadId,
    required this.strings,
  });

  final String spreadId;
  final CommonStrings strings;

  @override
  State<SpreadLessonScreen> createState() => _SpreadLessonScreenState();
}

class _SpreadLessonScreenState extends State<SpreadLessonScreen> {
  final _progressService = LearnProgressService();
  final _recommendationService = SpreadRecommendationService();
  SpreadEducational? _educational;
  List<SpreadBasicInfo> _similarSpreads = [];
  bool _isLoading = true;
  String? _error;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
    _fetchEducationalContent();
    _loadSimilarSpreads();
  }

  Future<void> _loadSimilarSpreads() async {
    final similar = await _recommendationService.findSimilarSpreads(
      spreadId: widget.spreadId,
      maxResults: 3,
      excludeCompleted: false,
    );
    if (mounted) {
      setState(() {
        _similarSpreads = similar;
      });
    }
  }

  Future<void> _loadCompletionStatus() async {
    final completed = await _progressService.isLessonCompleted(
      journeyId: 'spreads_journey',
      lessonId: widget.spreadId,
    );
    if (mounted) {
      setState(() {
        _isCompleted = completed;
      });
    }
  }

  Future<void> _fetchEducationalContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Get API URL from environment/config
      final apiUrl = 'http://localhost:3001'; // Development URL
      final response = await http.get(
        Uri.parse('$apiUrl/api/spread/educational/${widget.spreadId}'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true && json['data'] != null) {
          final educationalData = json['data']['educational'];
          setState(() {
            _educational = SpreadEducational.fromJson(educationalData);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Invalid response format';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load content: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleCompleted() async {
    final newStatus = !_isCompleted;

    if (newStatus) {
      await _progressService.markLessonComplete(
        journeyId: 'spreads_journey',
        lessonId: widget.spreadId,
      );
    } else {
      await _progressService.markLessonIncomplete(
        journeyId: 'spreads_journey',
        lessonId: widget.spreadId,
      );
    }

    if (mounted) {
      setState(() {
        _isCompleted = newStatus;
      });
    }
  }

  void _trySpreadNow() {
    // TODO: Navigate to reading screen with this spread preselected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getTrySpreadMessage(widget.strings.localeName)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.strings.localeName;
    final spreadInfo = getSpreadBasicInfoById(widget.spreadId);

    return Scaffold(
      backgroundColor: TarotTheme.veryLightLilacBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TarotTheme.deepNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          spreadInfo?.getName(locale) ?? widget.spreadId,
          style: const TextStyle(
            color: TarotTheme.deepNavy,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          // Mark complete toggle
          IconButton(
            icon: Icon(
              _isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: _isCompleted
                  ? const Color(0xFF10B981)
                  : TarotTheme.softBlueGrey,
            ),
            onPressed: _toggleCompleted,
            tooltip: _getCompleteTooltip(locale),
          ),
        ],
      ),
      body: _buildBody(locale, spreadInfo),
      floatingActionButton: _educational != null
          ? FloatingActionButton.extended(
              onPressed: _trySpreadNow,
              backgroundColor: const Color(0xFF06B6D4),
              icon: const Icon(Icons.play_arrow),
              label: Text(_getTryButtonLabel(locale)),
            )
          : null,
    );
  }

  Widget _buildBody(String locale, SpreadBasicInfo? spreadInfo) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF06B6D4)),
        ),
      );
    }

    if (_error != null) {
      return _ErrorState(
        message: _error!,
        locale: locale,
        onRetry: _fetchEducationalContent,
      );
    }

    if (_educational == null) {
      return _ErrorState(
        message: 'No educational content available',
        locale: locale,
        onRetry: _fetchEducationalContent,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero section with spread info
        if (spreadInfo != null)
          _HeroSection(
            spread: spreadInfo,
            locale: locale,
            isCompleted: _isCompleted,
          ),

        const SizedBox(height: 20),

        // Educational content panel (reusing FASE 3 widget!)
        SpreadEducationalPanel(
          educational: _educational!,
          locale: locale,
          showPositionInteractions: true,
        ),

        const SizedBox(height: 32),

        // Similar Spreads section
        if (_similarSpreads.isNotEmpty) ...[
          _SimilarSpreadsSection(
            similarSpreads: _similarSpreads,
            locale: locale,
            onSpreadTap: (spreadId) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SpreadLessonScreen(
                    spreadId: spreadId,
                    strings: widget.strings,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],

        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  String _getCompleteTooltip(String locale) {
    switch (locale) {
      case 'ca':
        return _isCompleted ? 'Marcar com a pendent' : 'Marcar com a completat';
      case 'es':
        return _isCompleted
            ? 'Marcar como pendiente'
            : 'Marcar como completado';
      default:
        return _isCompleted ? 'Mark as incomplete' : 'Mark as complete';
    }
  }

  String _getTryButtonLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Provar aquesta tirada';
      case 'es':
        return 'Probar esta tirada';
      default:
        return 'Try this spread';
    }
  }

  String _getTrySpreadMessage(String locale) {
    switch (locale) {
      case 'ca':
        return 'Aviat podràs provar aquesta tirada!';
      case 'es':
        return '¡Pronto podrás probar esta tirada!';
      default:
        return 'Soon you\'ll be able to try this spread!';
    }
  }
}

// ============================================================================
// Hero Section
// ============================================================================

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.spread,
    required this.locale,
    required this.isCompleted,
  });

  final SpreadBasicInfo spread;
  final String locale;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF06B6D4),
            Color(0xFF0891B2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Completion badge
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getCompletedLabel(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (isCompleted) const SizedBox(height: 16),

          // Spread name
          Text(
            spread.getName(locale),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            spread.getDescription(locale),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.style,
                label: _getCardsLabel(locale, spread.cardCount),
                value: '${spread.cardCount}',
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.signal_cellular_alt,
                label: spread.getComplexityLabel(locale),
                value: '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCompletedLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Completat';
      case 'es':
        return 'Completado';
      default:
        return 'Completed';
    }
  }

  String _getCardsLabel(String locale, int count) {
    switch (locale) {
      case 'ca':
        return count == 1 ? 'Carta' : 'Cartes';
      case 'es':
        return count == 1 ? 'Carta' : 'Cartas';
      default:
        return count == 1 ? 'Card' : 'Cards';
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (value.isNotEmpty)
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Similar Spreads Section
// ============================================================================

class _SimilarSpreadsSection extends StatelessWidget {
  const _SimilarSpreadsSection({
    required this.similarSpreads,
    required this.locale,
    required this.onSpreadTap,
  });

  final List<SpreadBasicInfo> similarSpreads;
  final String locale;
  final void Function(String spreadId) onSpreadTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.explore,
                  color: Color(0xFF06B6D4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(locale),
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(locale),
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Similar spreads list
          ...similarSpreads.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < similarSpreads.length - 1 ? 12 : 0,
                  ),
                  child: _SimilarSpreadCard(
                    spread: entry.value,
                    locale: locale,
                    onTap: () => onSpreadTap(entry.value.id),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades Similars';
      case 'es':
        return 'Tiradas Similares';
      default:
        return 'Similar Spreads';
    }
  }

  String _getSubtitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Si t\'agrada aquesta, prova aquestes';
      case 'es':
        return 'Si te gusta esta, prueba estas';
      default:
        return 'If you like this, try these';
    }
  }
}

class _SimilarSpreadCard extends StatelessWidget {
  const _SimilarSpreadCard({
    required this.spread,
    required this.locale,
    required this.onTap,
  });

  final SpreadBasicInfo spread;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: TarotTheme.skyBlueLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Card count badge
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${spread.cardCount}',
                  style: const TextStyle(
                    color: Color(0xFF06B6D4),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Spread info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spread.getName(locale),
                    style: const TextStyle(
                      color: TarotTheme.deepNavy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spread.getComplexityLabel(locale),
                    style: TextStyle(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward,
              color: const Color(0xFF06B6D4).withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Error State
// ============================================================================

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.locale,
    required this.onRetry,
  });

  final String message;
  final String locale;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TarotTheme.softBlueGrey,
            ),
            const SizedBox(height: 24),
            Text(
              _getErrorTitle(locale),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(_getRetryLabel(locale)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'No s\'ha pogut carregar el contingut';
      case 'es':
        return 'No se pudo cargar el contenido';
      default:
        return 'Could not load content';
    }
  }

  String _getRetryLabel(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tornar a intentar';
      case 'es':
        return 'Reintentar';
      default:
        return 'Retry';
    }
  }
}
