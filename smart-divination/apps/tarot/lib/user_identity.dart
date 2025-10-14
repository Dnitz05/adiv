import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'auth/auth_exceptions.dart';

class UserIdentity {
  static const String _guestUserIdKey = 'guest_user_id';
  static const Uuid _uuid = Uuid();

  static Future<String> obtain() async {
    print('[UserIdentity] Starting obtain()');

    // For freemium/anonymous mode: first try to get/create a local guest ID
    final prefs = await SharedPreferences.getInstance();
    String? guestId = prefs.getString(_guestUserIdKey);

    if (guestId != null && guestId.isNotEmpty) {
      print('[UserIdentity] Using existing guest ID: $guestId');
      return guestId;
    }

    // Try to get authenticated Supabase user if available
    try {
      final client = Supabase.instance.client;
      final currentUser = client.auth.currentUser;
      print('[UserIdentity] Current user: ${currentUser?.id}');
      if (currentUser != null) {
        return currentUser.id;
      }

      print('[UserIdentity] Attempting to refresh session');
      final response = await client.auth.refreshSession();
      final refreshedUser = response.session?.user;
      print('[UserIdentity] Refresh result: ${refreshedUser?.id}');
      if (refreshedUser != null) {
        return refreshedUser.id;
      }
    } catch (e) {
      print('[UserIdentity] Supabase auth not available: $e');
      // Continue to create guest ID below
    }

    // Create and store a new guest ID for anonymous users
    print('[UserIdentity] Creating new guest ID');
    guestId = _uuid.v4();
    await prefs.setString(_guestUserIdKey, guestId);
    print('[UserIdentity] Created guest ID: $guestId');
    return guestId;
  }

  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestUserIdKey);
  }
}
