import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import '../auth/auth_exceptions.dart';

const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3001',
);

Uri buildApiUri(String path, [Map<String, String>? queryParameters]) {
  print('🌐 DEBUG: Building API URI with base: $kApiBaseUrl');
  final normalisedBase =
      kApiBaseUrl.endsWith('/') ? kApiBaseUrl : '$kApiBaseUrl/';
  final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
  final baseUri = Uri.parse(normalisedBase);
  final resolved = baseUri.resolveUri(Uri(path: trimmedPath));
  if (queryParameters == null || queryParameters.isEmpty) {
    print('🌐 DEBUG: Final URI: $resolved');
    return resolved;
  }
  final mergedQuery = <String, String>{
    ...resolved.queryParameters,
    ...queryParameters,
  };
  final finalUri = resolved.replace(queryParameters: mergedQuery);
  print('🌐 DEBUG: Final URI with query: $finalUri');
  return finalUri;
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
  final headers = <String, String>{};

  // Anonymous users: skip authorization header
  if (userId != null && userId.startsWith('anon_')) {
    headers['x-user-id'] = userId;
  } else {
    // Registered users: include authorization token
    final token = await _requireAccessToken();
    headers['authorization'] = 'Bearer $token';
    if (userId != null && userId.isNotEmpty) {
      headers['x-user-id'] = userId;
    }
  }

  if (locale != null && locale.isNotEmpty) {
    headers['x-locale'] = locale;
  }
  if (additional != null && additional.isNotEmpty) {
    headers.addAll(additional);
  }
  return headers;
}
