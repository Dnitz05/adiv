import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import '../auth/auth_exceptions.dart';

const String _environmentApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '',
);

const String _localDevelopmentApiBase = 'http://localhost:3001';
const bool _useLocalApi =
    bool.fromEnvironment('USE_LOCAL_API', defaultValue: false);
const String _productionApiBase =
    'https://backend-oa36zc9t6-dnitzs-projects.vercel.app';

String? _runtimeApiBaseOverride;

String _resolveApiBaseUrl() {
  final override = _runtimeApiBaseOverride;
  if (override != null && override.isNotEmpty) {
    return override;
  }

  if (_environmentApiBaseUrl.isNotEmpty) {
    return _environmentApiBaseUrl;
  }

  if (kReleaseMode) {
    return _productionApiBase;
  }

  if (_useLocalApi) {
    return _localDevelopmentApiBase;
  }

  return _productionApiBase;
}

void setApiBaseUrlOverride(String? override) {
  _runtimeApiBaseOverride = override?.trim();
}

Uri buildApiUri(String path, [Map<String, String>? queryParameters]) {
  final baseUrl = _resolveApiBaseUrl();
  print('[API] Building URI with base: $baseUrl');
  final normalisedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
  final baseUri = Uri.parse(normalisedBase);
  final resolved = baseUri.resolveUri(Uri(path: trimmedPath));
  if (queryParameters == null || queryParameters.isEmpty) {
    print('[API] Final URI: $resolved');
    return resolved;
  }
  final mergedQuery = <String, String>{
    ...resolved.queryParameters,
    ...queryParameters,
  };
  final finalUri = resolved.replace(queryParameters: mergedQuery);
  print('[API] Final URI with query: $finalUri');
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

  // Determine if user is anonymous
  final isAnonymous = userId != null && userId.startsWith('anon_');

  if (isAnonymous) {
    // Anonymous users: only send x-user-id header
    print('[API] Using anonymous authentication with userId: $userId');
    headers['x-user-id'] = userId;
  } else if (userId != null && userId.isNotEmpty) {
    // Registered users with explicit userId
    print('[API] Using registered user authentication with userId: $userId');
    try {
      final token = await _requireAccessToken();
      headers['authorization'] = 'Bearer $token';
      headers['x-user-id'] = userId;
    } catch (e) {
      print(
          '[API] WARN Failed to get access token: $e');
      // Fall back to anonymous mode if token fetch fails
      headers['x-user-id'] = userId;
    }
  } else {
    // No userId provided - try to get token if available
    print('[API] No userId provided, attempting to get token');
    try {
      final token = await _requireAccessToken();
      headers['authorization'] = 'Bearer $token';
    } catch (e) {
      print(
          '[API] WARN No authentication available: $e');
      // No authentication - API will handle this
    }
  }

  if (locale != null && locale.isNotEmpty) {
    headers['x-locale'] = locale;
  }
  if (additional != null && additional.isNotEmpty) {
    headers.addAll(additional);
  }

  print('[API] Final headers keys: ${headers.keys.join(", ")}');
  return headers;
}
