import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import 'auth/auth_exceptions.dart';

class UserIdentity {
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
      // Ignore refresh failures; caller will receive the auth exception below.
    }

    throw const AuthRequiredException();
  }

  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
