import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'auth/auth_exceptions.dart';

class UserIdentity {
  static const _anonUserIdKey = 'anon_user_id';

  static Future<String> obtain() async {
    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;
    if (currentUser != null) {
      return currentUser.id;
    }

    try {
      final response = await client.auth.refreshSession();
      final refreshedUser = response.session?.user;
      if (refreshedUser != null) {
        return refreshedUser.id;
      }
    } catch (_) {
      // Ignore refresh failures; fall through to anonymous flow.
    }

    // Generate or retrieve anonymous UUID
    return _getOrCreateAnonymousId();
  }

  static Future<String> _getOrCreateAnonymousId() async {
    final prefs = await SharedPreferences.getInstance();
    String? anonId = prefs.getString(_anonUserIdKey);

    if (anonId == null || anonId.isEmpty) {
      anonId = 'anon_${const Uuid().v4().replaceAll('-', '')}';
      await prefs.setString(_anonUserIdKey, anonId);
    }

    return anonId;
  }

  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
