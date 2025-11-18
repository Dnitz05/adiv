import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/lunar_guide.dart';
import '../models/lunar_guide_template.dart';
import '../models/daily_lunar_insight.dart';
import '../services/lunar_calculator_service.dart';

/// Service for fetching and managing lunar guides
/// Implements fallback logic: Modular composed insight → element template → generic template
class LunarGuideService {
  final SupabaseClient _supabase;
  final LunarCalculatorService _lunarCalculator;

  // Cache keys
  static const String _cacheKeyPrefix = 'lunar_guide_';
  static const String _cacheTimestampPrefix = 'lunar_guide_ts_';
  static const Duration _cacheValidity = Duration(hours: 6);

  LunarGuideService({
    SupabaseClient? supabase,
    LunarCalculatorService? lunarCalculator,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _lunarCalculator = lunarCalculator ?? LunarCalculatorService();

  /// Get lunar guide for today
  /// Implements intelligent fallback:
  /// 1. Try to get modular-composed daily insight (base + seasonal + weekday + events)
  /// 2. If not available, use element-specific template
  /// 3. If that fails, use generic phase template
  Future<LunarGuide> getTodaysGuide({
    bool forceRefresh = false,
  }) async {
    final today = DateTime.now();
    return getGuideForDate(today, forceRefresh: forceRefresh);
  }

  /// Get lunar guide for specific date
  Future<LunarGuide> getGuideForDate(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final dateString = _formatDate(date);

    // Check cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedGuide = await _getCachedGuide(dateString);
      if (cachedGuide != null) {
        return cachedGuide;
      }
    }

    // Calculate lunar data for this date
    final lunarData = _lunarCalculator.calculateLunarPhase(date);
    final phaseId = _lunarCalculator.getPhaseId(lunarData.phase);
    final zodiacSign = _lunarCalculator.getZodiacSign(date);
    final element = _lunarCalculator.getElementFromZodiac(zodiacSign);

    print('🌙 Looking for template: phase=$phaseId, zodiac=$zodiacSign, element=$element');

    // Step 1: Try to fetch modular-composed daily insight
    final dailyInsight = await _fetchDailyInsight(dateString);

    // Step 2: Fetch matching template with fallback logic
    final template = await _fetchBestMatchingTemplate(
      phaseId: phaseId,
      zodiacSign: zodiacSign,
      element: element,
    );

    if (template == null) {
      print('❌ No template found for phase: $phaseId');
      throw Exception('No lunar guide template found for phase $phaseId');
    }

    print('✅ Found template: ${template.id}');

    // Combine template + daily insight (if available)
    final guide = LunarGuide(
      template: template,
      dailyInsight: dailyInsight,
    );

    // Cache the result
    await _cacheGuide(dateString, guide);

    return guide;
  }

  /// Fetch daily modular-composed insight
  Future<DailyLunarInsight?> _fetchDailyInsight(String dateString) async {
    try {
      print('🔍 Fetching daily insight for: $dateString');
      final response = await _supabase
          .from('daily_lunar_insights')
          .select()
          .eq('date', dateString)
          .maybeSingle();

      if (response == null) {
        print('⚠️ No daily insight found for $dateString');
        return null;
      }

      print('✅ Found daily insight data: ${response.keys}');
      final insight = DailyLunarInsight.fromJson(response);
      print('✅ Successfully parsed daily insight for $dateString');
      return insight;
    } catch (e, stackTrace) {
      print('❌ Error fetching daily insight: $e');
      print('Stack trace: $stackTrace');
      return null; // Graceful fallback
    }
  }

  /// Fetch best matching template with priority fallback:
  /// 1. Zodiac-specific template (priority 2)
  /// 2. Element-specific template (priority 1)
  /// 3. Generic phase template (priority 0)
  Future<LunarGuideTemplate?> _fetchBestMatchingTemplate({
    required String phaseId,
    required String zodiacSign,
    required String element,
  }) async {
    try {
      print('🔍 Fetching templates for phase: $phaseId');

      // Fetch all active templates for this phase, ordered by priority
      final response = await _supabase
          .from('lunar_guide_templates')
          .select()
          .eq('phase_id', phaseId)
          .eq('active', true)
          .order('priority', ascending: false)
          .limit(10);

      print('📦 Response type: ${response.runtimeType}');
      print('📦 Response: $response');

      if (response == null || (response as List).isEmpty) {
        print('❌ No templates found in response');
        return null;
      }

      final templates = (response as List)
          .map((json) => LunarGuideTemplate.fromJson(json))
          .toList();

      // Try zodiac-specific first
      var template = templates.firstWhere(
        (t) => t.zodiacSign == zodiacSign,
        orElse: () => templates.firstWhere(
          // Try element-specific
          (t) => t.element == element && t.zodiacSign == null,
          orElse: () => templates.firstWhere(
            // Fallback to generic
            (t) => t.element == null && t.zodiacSign == null,
            orElse: () => templates.first, // Last resort: any template
          ),
        ),
      );

      return template;
    } catch (e) {
      print('Error fetching template: $e');
      return null;
    }
  }

  /// Prefetch guides for the next 7 days
  /// Useful for offline support and smooth UX
  Future<void> prefetchUpcomingGuides() async {
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = today.add(Duration(days: i));
      try {
        await getGuideForDate(date);
      } catch (e) {
        print('Error prefetching guide for $date: $e');
      }
    }
  }

  /// Clear all cached guides
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cacheKeyPrefix) ||
          key.startsWith(_cacheTimestampPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  // Cache management

  Future<LunarGuide?> _getCachedGuide(String dateString) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if cache is still valid
      final timestampKey = '$_cacheTimestampPrefix$dateString';
      final timestamp = prefs.getInt(timestampKey);
      if (timestamp == null) return null;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheValidity) {
        // Cache expired
        await prefs.remove('$_cacheKeyPrefix$dateString');
        await prefs.remove(timestampKey);
        return null;
      }

      // Get cached data
      final cacheKey = '$_cacheKeyPrefix$dateString';
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson == null) return null;

      final data = json.decode(cachedJson);

      // Reconstruct LunarGuide
      final template = LunarGuideTemplate.fromJson(data['template']);
      final dailyInsight = data['dailyInsight'] != null
          ? DailyLunarInsight.fromJson(data['dailyInsight'])
          : null;

      return LunarGuide(
        template: template,
        dailyInsight: dailyInsight,
      );
    } catch (e) {
      print('Error reading cache: $e');
      return null;
    }
  }

  Future<void> _cacheGuide(String dateString, LunarGuide guide) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final data = {
        'template': guide.template.toJson(),
        'dailyInsight': guide.dailyInsight?.toJson(),
      };

      final cacheKey = '$_cacheKeyPrefix$dateString';
      final timestampKey = '$_cacheTimestampPrefix$dateString';

      await prefs.setString(cacheKey, json.encode(data));
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error writing cache: $e');
    }
  }

  /// Get all 8 generic phase templates for educational purposes
  Future<List<LunarGuideTemplate>> getAllPhaseTemplates() async {
    try {
      final response = await _supabase
          .from('lunar_guide_templates')
          .select()
          .isFilter('zodiac_sign', null)
          .isFilter('element', null)
          .eq('active', true)
          .order('phase_id');

      if (response == null || (response as List).isEmpty) {
        return [];
      }

      // Define phase order
      final phaseOrder = [
        'new_moon',
        'waxing_crescent',
        'first_quarter',
        'waxing_gibbous',
        'full_moon',
        'waning_gibbous',
        'last_quarter',
        'waning_crescent',
      ];

      final templates = (response as List)
          .map((json) => LunarGuideTemplate.fromJson(json))
          .toList();

      // Sort by custom phase order
      templates.sort((a, b) {
        final indexA = phaseOrder.indexOf(a.phaseId);
        final indexB = phaseOrder.indexOf(b.phaseId);
        return indexA.compareTo(indexB);
      });

      return templates;
    } catch (e) {
      print('Error fetching all phase templates: $e');
      return [];
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
