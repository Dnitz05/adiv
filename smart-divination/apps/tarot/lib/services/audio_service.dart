import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _enabled = true;

  /// Enable or disable sound effects
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  bool get isEnabled => _enabled;

  /// Play card flip sound effect
  Future<void> playCardFlip() async {
    if (!_enabled) return;

    try {
      await _player.play(AssetSource('sounds/card_flip.wav'));
    } catch (e) {
      debugPrint('Error playing card flip sound: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _player.dispose();
  }
}
