import 'dart:convert';
import '../../shared/models/contracts.dart';

// Placeholder implementation - would use Isar in real app
class SessionRepository {
  final Map<String, SessionState> _sessions = {};
  final Map<String, List<SessionState>> _userSessions = {};

  Future<void> saveSession(SessionState session) async {
    _sessions[session.sessionId] = session;
    
    final userSessions = _userSessions[session.userId] ?? [];
    final existingIndex = userSessions.indexWhere((s) => s.sessionId == session.sessionId);
    
    if (existingIndex >= 0) {
      userSessions[existingIndex] = session;
    } else {
      userSessions.add(session);
    }
    
    _userSessions[session.userId] = userSessions;
  }

  Future<SessionState?> getSession(String sessionId) async {
    return _sessions[sessionId];
  }

  Future<List<SessionState>> getUserSessions(String userId, {int limit = 20}) async {
    final sessions = _userSessions[userId] ?? [];
    sessions.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
    return sessions.take(limit).toList();
  }

  Future<void> deleteSession(String sessionId) async {
    final session = _sessions[sessionId];
    if (session != null) {
      _sessions.remove(sessionId);
      final userSessions = _userSessions[session.userId] ?? [];
      userSessions.removeWhere((s) => s.sessionId == sessionId);
      _userSessions[session.userId] = userSessions;
    }
  }

  Future<void> clearUserHistory(String userId) async {
    final sessions = _userSessions[userId] ?? [];
    for (final session in sessions) {
      _sessions.remove(session.sessionId);
    }
    _userSessions[userId] = [];
  }

  Future<int> getUserSessionCount(String userId) async {
    return _userSessions[userId]?.length ?? 0;
  }

  Future<List<SessionState>> searchSessions({
    required String userId,
    String? query,
    DivinationTechnique? technique,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 20,
  }) async {
    var sessions = _userSessions[userId] ?? [];
    
    if (technique != null) {
      sessions = sessions.where((s) => s.technique == technique).toList();
    }
    
    if (startDate != null) {
      sessions = sessions.where((s) => s.createdAt.isAfter(startDate)).toList();
    }
    
    if (endDate != null) {
      sessions = sessions.where((s) => s.createdAt.isBefore(endDate)).toList();
    }
    
    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      sessions = sessions.where((s) {
        final topicMatch = s.topic?.toLowerCase().contains(queryLower) ?? false;
        final messageMatch = s.messages.any((m) => 
            m.content.toLowerCase().contains(queryLower));
        return topicMatch || messageMatch;
      }).toList();
    }
    
    sessions.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
    return sessions.take(limit).toList();
  }

  // Statistics
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final sessions = _userSessions[userId] ?? [];
    
    final totalSessions = sessions.length;
    final techniqueCount = <DivinationTechnique, int>{};
    int totalMessages = 0;
    
    for (final session in sessions) {
      if (session.technique != null) {
        techniqueCount[session.technique!] = 
            (techniqueCount[session.technique!] ?? 0) + 1;
      }
      totalMessages += session.messages.length;
    }
    
    final mostUsedTechnique = techniqueCount.entries.isEmpty
        ? null
        : techniqueCount.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
    
    return {
      'total_sessions': totalSessions,
      'total_messages': totalMessages,
      'most_used_technique': mostUsedTechnique?.name,
      'technique_breakdown': techniqueCount.map(
          (key, value) => MapEntry(key.name, value)),
      'first_session': sessions.isEmpty 
          ? null 
          : sessions.map((s) => s.createdAt).reduce(
              (a, b) => a.isBefore(b) ? a : b).toIso8601String(),
      'last_session': sessions.isEmpty 
          ? null 
          : sessions.map((s) => s.lastActivity).reduce(
              (a, b) => a.isAfter(b) ? a : b).toIso8601String(),
    };
  }

  // Export functionality
  Future<String> exportUserData(String userId, {String format = 'json'}) async {
    final sessions = _userSessions[userId] ?? [];
    
    if (format == 'json') {
      return jsonEncode({
        'user_id': userId,
        'export_date': DateTime.now().toIso8601String(),
        'sessions': sessions.map((s) => s.toJson()).toList(),
      });
    }
    
    throw UnsupportedError('Format $format not supported');
  }

  // Backup and restore
  Future<void> importUserData(String userId, String data) async {
    final imported = jsonDecode(data);
    final sessions = (imported['sessions'] as List)
        .map((s) => SessionState.fromJson(s))
        .toList();
    
    _userSessions[userId] = sessions;
    
    for (final session in sessions) {
      _sessions[session.sessionId] = session;
    }
  }
}