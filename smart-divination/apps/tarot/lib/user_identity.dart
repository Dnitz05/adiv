import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'auth/auth_exceptions.dart';

class UserIdentity {
  static const String _guestUserIdKey = 'guest_user_id';
  static const Uuid _uuid = Uuid();

  static Future<String> obtain() async {
    print('[UserIdentity] Starting obtain()');
    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;
    print('[UserIdentity] Current user: ${currentUser?.id}');
    if (currentUser != null) {
      return currentUser.id;
    }

    print('[UserIdentity] Attempting to refresh session');
    try {
      final response = await client.auth.refreshSession();
      final refreshedUser = response.session?.user;
      print('[UserIdentity] Refresh result: ${refreshedUser?.id}');
      if (refreshedUser != null) {
        return refreshedUser.id;
      }
    } catch (e) {
      print('[UserIdentity] Refresh failed: $e');
      // Ignore refresh failures; will sign in anonymously below
    }

    // Sign in anonymously to get a valid Supabase session
    print('[UserIdentity] Attempting anonymous sign-in');
    try {
      final response = await client.auth.signInAnonymously();
      print('[UserIdentity] signInAnonymously response received');
      final anonUser = response.session?.user;
      print('[UserIdentity] Anonymous user: ${anonUser?.id}');
      if (anonUser != null) {
        return anonUser.id;
      }
    } catch (e) {
      print('[UserIdentity] ❌ FAILED to sign in anonymously: $e');
      print('[UserIdentity] Error type: ${e.runtimeType}');
      throw Exception('Could not authenticate: $e');
    }

    print('[UserIdentity] ❌ Could not obtain user identity - no error but no user');
    throw Exception('Could not obtain user identity');
  }

  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestUserIdKey);
  }
}
