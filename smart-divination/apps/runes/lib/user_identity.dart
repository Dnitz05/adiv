import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class UserIdentity {
  static const _storageKey = 'user_id';

  static Future<String> obtain() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_storageKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final generated = _generateId();
    await prefs.setString(_storageKey, generated);
    return generated;
  }

  static String _generateId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
