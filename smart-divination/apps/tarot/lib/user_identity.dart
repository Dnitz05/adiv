import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserIdentity {
  static const _anonUserIdKey = 'anon_user_id';
  static String? _cachedUserId;
  static Future<SharedPreferences>? _prefsFuture;

  static Future<String> obtain() async {
    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;
    if (currentUser != null) {
      final id = currentUser.id;
      if (_cachedUserId != id) {
        _cachedUserId = id;
      }
      return id;
    }

    final cached = _cachedUserId;
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    try {
      final response = await client.auth.refreshSession();
      final refreshedUser = response.session?.user;
      if (refreshedUser != null) {
        final id = refreshedUser.id;
        _cachedUserId = id;
        return id;
      }
    } catch (_) {
      // Ignore refresh failures; fall through to anonymous flow.
    }

    // Generate or retrieve anonymous UUID
    final anonId = await _getOrCreateAnonymousId();
    _cachedUserId = anonId;
    return anonId;
  }

  static Future<String> _getOrCreateAnonymousId() async {
    _prefsFuture ??= SharedPreferences.getInstance();
    final prefs = await _prefsFuture!;
    String? anonId = prefs.getString(_anonUserIdKey);

    if (anonId == null || anonId.isEmpty) {
      anonId = 'anon_${const Uuid().v4().replaceAll('-', '')}';
      await prefs.setString(_anonUserIdKey, anonId);
    }

    return anonId;
  }

  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _cachedUserId = null;
  }
}
