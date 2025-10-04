import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';

class SessionLimits {
  SessionLimits({
    required this.perDay,
    required this.perWeek,
    required this.perMonth,
  });

  final int perDay;
  final int perWeek;
  final int perMonth;

  factory SessionLimits.fromJson(Map<String, dynamic> json) => SessionLimits(
        perDay: (json['sessionsPerDay'] as num?)?.toInt() ?? 0,
        perWeek: (json['sessionsPerWeek'] as num?)?.toInt() ?? 0,
        perMonth: (json['sessionsPerMonth'] as num?)?.toInt() ?? 0,
      );
}

class SessionUsage {
  SessionUsage({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });

  final int today;
  final int thisWeek;
  final int thisMonth;

  factory SessionUsage.fromJson(Map<String, dynamic> json) => SessionUsage(
        today: (json['sessionsToday'] as num?)?.toInt() ?? 0,
        thisWeek: (json['sessionsThisWeek'] as num?)?.toInt() ?? 0,
        thisMonth: (json['sessionsThisMonth'] as num?)?.toInt() ?? 0,
      );
}

class SessionEligibility {
  SessionEligibility({
    required this.canStart,
    required this.tier,
    required this.limits,
    required this.usage,
    this.reason,
    this.nextAllowedAt,
  });

  final bool canStart;
  final String tier;
  final SessionLimits limits;
  final SessionUsage usage;
  final String? reason;
  final DateTime? nextAllowedAt;

  factory SessionEligibility.fromJson(Map<String, dynamic> json) {
    DateTime? nextAllowed;
    final nextAllowedRaw = json['nextAllowedAt'] as String?;
    if (nextAllowedRaw != null && nextAllowedRaw.isNotEmpty) {
      nextAllowed = DateTime.tryParse(nextAllowedRaw)?.toLocal();
    }

    return SessionEligibility(
      canStart: json['can_start'] as bool? ?? true,
      tier: json['tier'] as String? ?? 'free',
      limits: SessionLimits.fromJson(
        json['limits'] as Map<String, dynamic>? ?? const {},
      ),
      usage: SessionUsage.fromJson(
        json['usage'] as Map<String, dynamic>? ?? const {},
      ),
      reason: json['reason'] as String?,
      nextAllowedAt: nextAllowed,
    );
  }
}

Future<SessionEligibility> fetchSessionEligibility(
    {required String userId}) async {
  final uri = buildApiUri('api/users/$userId/can-start-session');
  final headers = await buildAuthenticatedHeaders(
    userId: userId,
    additional: {
      'accept': 'application/json',
    },
  );
  final res = await http.get(
    uri,
    headers: headers,
  );

  if (res.statusCode != 200) {
    throw Exception(
        'Session eligibility failed (${res.statusCode}): ${res.body}');
  }

  final Map<String, dynamic> payload =
      jsonDecode(res.body) as Map<String, dynamic>;
  if (payload['success'] != true) {
    final error = payload['error'];
    throw Exception('Session eligibility failed: ${error ?? payload}');
  }

  final data = payload['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
  return SessionEligibility.fromJson(data);
}
