import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _enabled = true;

  /// Enable or disable sound effects
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  bool get isEnabled => _enabled;

  /// Play card flip sound effect
  /// Creates a new player for each sound to avoid overlap issues
  Future<void> playCardFlip() async {
    if (!_enabled) return;

    try {
      // Create a new player for each sound to allow overlapping
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release); // Auto-dispose when done
      await player.play(AssetSource('sounds/card_flip.wav'));
    } catch (e) {
      debugPrint('Error playing card flip sound: $e');
    }
  }

  /// Play card deal sound effect (softer swish for dealing cards)
  /// Creates a new player for each sound to avoid overlap issues
  Future<void> playCardDeal() async {
    if (!_enabled) return;

    try {
      // Create a new player for each sound to allow overlapping
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release); // Auto-dispose when done
      await player.play(AssetSource('sounds/card_deal.wav'));
    } catch (e) {
      debugPrint('Error playing card deal sound: $e');
    }
  }
}
