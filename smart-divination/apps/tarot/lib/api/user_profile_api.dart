import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';

class UserProfileTechnique {
  UserProfileTechnique({
    required this.value,
    required this.count,
  });

  final String value;
  final int count;
}

class UserProfileKeyword {
  UserProfileKeyword({
    required this.value,
    required this.count,
  });

  final String value;
  final int count;
}

class UserProfile {
  UserProfile({
    required this.userId,
    required this.sessionCount,
    required this.techniques,
    required this.techniqueCounts,
    required this.topKeywords,
    required this.keywords,
    this.recentQuestion,
    this.recentInterpretation,
    this.lastSessionAt,
  });

  final String userId;
  final int sessionCount;
  final List<String> techniques;
  final List<UserProfileTechnique> techniqueCounts;
  final List<UserProfileKeyword> topKeywords;
  final List<UserProfileKeyword> keywords;
  final String? recentQuestion;
  final String? recentInterpretation;
  final String? lastSessionAt;
}

UserProfile _mapUserProfile(Map<String, dynamic> data) {
  List<UserProfileTechnique> parseTechniqueCounts() {
    final list = data['techniqueCounts'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((entry) => UserProfileTechnique(
              value: (entry['value'] as String?) ?? 'unknown',
              count: (entry['count'] as num?)?.toInt() ?? 0,
            ))
        .toList();
  }

  List<UserProfileKeyword> parseKeywords(String key) {
    final list = data[key] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((entry) => UserProfileKeyword(
              value: (entry['value'] as String?) ?? '',
              count: (entry['count'] as num?)?.toInt() ?? 0,
            ))
        .where((keyword) => keyword.value.isNotEmpty)
        .toList();
  }

  return UserProfile(
    userId: data['userId'] as String? ?? '',
    sessionCount: (data['sessionCount'] as num?)?.toInt() ?? 0,
    techniques: (data['techniques'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(),
    techniqueCounts: parseTechniqueCounts(),
    topKeywords: parseKeywords('topKeywords'),
    keywords: parseKeywords('keywords'),
    recentQuestion: data['recentQuestion'] as String?,
    recentInterpretation: data['recentInterpretation'] as String?,
    lastSessionAt: data['lastSessionAt'] as String?,
  );
}

Future<UserProfile?> fetchUserProfile({
  required String userId,
  int limit = 50,
}) async {
  final uri = buildApiUri('api/users/$userId/profile', {
    'limit': '$limit',
  });

  final headers = await buildAuthenticatedHeaders(
    userId: userId,
    additional: {
      'accept': 'application/json',
    },
  );

  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 503) {
    // Supabase unavailable; treat as optional feature.
    return null;
  }

  if (response.statusCode != 200) {
    throw Exception(
        'Profile fetch failed (${response.statusCode}): ${response.body}');
  }

  final Map<String, dynamic> payload =
      jsonDecode(response.body) as Map<String, dynamic>;
  if (payload['success'] != true) {
    final error = payload['error'];
    throw Exception('Profile fetch failed: ${error ?? payload}');
  }

  final data = payload['data'] as Map<String, dynamic>?;
  if (data == null) {
    return null;
  }

  return _mapUserProfile(data);
}
