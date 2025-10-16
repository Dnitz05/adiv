import 'dart:async';
import 'package:flutter/services.dart';

class DailyQuote {
  final String es;
  final String ca;
  final String en;
  final String author;

  DailyQuote({
    required this.es,
    required this.ca,
    required this.en,
    required this.author,
  });

  String getText(String locale) {
    if (locale.startsWith('ca')) return ca;
    if (locale.startsWith('es')) return es;
    return en;
  }
}

class DailyQuoteService {
  static List<DailyQuote>? _quotes;
  static DateTime? _lastLoadDate;

  static Future<void> _loadQuotes() async {
    if (_quotes != null && _lastLoadDate != null) {
      // Check if we're still on the same day
      final now = DateTime.now();
      if (now.year == _lastLoadDate!.year &&
          now.month == _lastLoadDate!.month &&
          now.day == _lastLoadDate!.day) {
        return; // Already loaded today
      }
    }

    try {
      final csvString = await rootBundle.loadString('assets/daily-quotes.csv');
      final lines = csvString.split('\n').skip(1); // Skip header

      _quotes = [];
      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        final parts = _parseCsvLine(line);
        if (parts.length >= 5) {
          _quotes!.add(DailyQuote(
            es: parts[1],
            ca: parts[2],
            en: parts[3],
            author: parts[4],
          ));
        }
      }
      _lastLoadDate = DateTime.now();
    } catch (e) {
      print('Error loading daily quotes: $e');
      _quotes = [];
    }
  }

  static List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    bool inQuotes = false;
    StringBuffer current = StringBuffer();

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString().trim());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString().trim());

    return result;
  }

  static Future<DailyQuote?> getTodayQuote() async {
    await _loadQuotes();

    if (_quotes == null || _quotes!.isEmpty) {
      return null;
    }

    // Calculate day of year (1-365/366)
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays + 1;

    // Use modulo to loop through quotes
    final index = (dayOfYear - 1) % _quotes!.length;
    return _quotes![index];
  }
}
