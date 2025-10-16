import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to store conversations locally
class LocalStorageService {
  static const String _conversationsKey = 'saved_conversations';
  static const int _maxConversations = 50; // Limit to avoid storage issues

  /// Save a conversation locally
  static Future<void> saveConversation({
    required String question,
    required String spread,
    required List<Map<String, dynamic>> cards,
    String? interpretation,
    String? summary,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing conversations
      final conversations = await getConversations();

      // Create new conversation object
      final newConversation = {
        'timestamp': DateTime.now().toIso8601String(),
        'question': question,
        'spread': spread,
        'cards': cards,
        'interpretation': interpretation,
        'summary': summary,
      };

      // Add to beginning of list
      conversations.insert(0, newConversation);

      // Keep only last N conversations
      if (conversations.length > _maxConversations) {
        conversations.removeRange(_maxConversations, conversations.length);
      }

      // Save to storage
      final jsonString = jsonEncode(conversations);
      await prefs.setString(_conversationsKey, jsonString);
    } catch (e) {
      print('Error saving conversation: $e');
    }
  }

  /// Get all saved conversations
  static Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_conversationsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading conversations: $e');
      return [];
    }
  }

  /// Clear all saved conversations
  static Future<void> clearConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_conversationsKey);
    } catch (e) {
      print('Error clearing conversations: $e');
    }
  }

  /// Get conversation count
  static Future<int> getConversationCount() async {
    final conversations = await getConversations();
    return conversations.length;
  }
}
