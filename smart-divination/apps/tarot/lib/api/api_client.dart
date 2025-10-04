import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import '../auth/auth_exceptions.dart';

const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3001',
);

Uri buildApiUri(String path, [Map<String, String>? queryParameters]) {
  final normalisedBase =
      kApiBaseUrl.endsWith('/') ? kApiBaseUrl : '$kApiBaseUrl/';
  final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
  final baseUri = Uri.parse(normalisedBase);
  final resolved = baseUri.resolveUri(Uri(path: trimmedPath));
  if (queryParameters == null || queryParameters.isEmpty) {
    return resolved;
  }
  final mergedQuery = <String, String>{
    ...resolved.queryParameters,
    ...queryParameters,
  };
  return resolved.replace(queryParameters: mergedQuery);
}

Future<String> _requireAccessToken() async {
  final client = Supabase.instance.client;
  final currentSession = client.auth.currentSession;
  if (currentSession != null && currentSession.accessToken.isNotEmpty) {
    return currentSession.accessToken;
  }

  try {
    final response = await client.auth.refreshSession();
    final refreshed = response.session;
    if (refreshed != null && refreshed.accessToken.isNotEmpty) {
      return refreshed.accessToken;
    }
  } catch (_) {
    // Ignore refresh errors; we'll throw below.
  }

  throw const AuthRequiredException();
}

Future<Map<String, String>> buildAuthenticatedHeaders({
  String? locale,
  String? userId,
  Map<String, String>? additional,
}) async {
  final token = await _requireAccessToken();
  final headers = <String, String>{
    'authorization': 'Bearer $token',
  };
  if (locale != null && locale.isNotEmpty) {
    headers['x-locale'] = locale;
  }
  if (userId != null && userId.isNotEmpty) {
    headers['x-user-id'] = userId;
  }
  if (additional != null && additional.isNotEmpty) {
    headers.addAll(additional);
  }
  return headers;
}
