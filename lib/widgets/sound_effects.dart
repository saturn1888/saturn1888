import 'package:audioplayers/audioplayers.dart';

/// Simple sound effects player for gameplay
class SoundEffects {
  static final _player = AudioPlayer();

  static Future<void> playFound() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/found.wav'));
    } catch (_) {}
  }

  static Future<void> playTick() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/tick.wav'));
    } catch (_) {}
  }

  static Future<void> playGo() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/go.wav'));
    } catch (_) {}
  }

  static Future<void> playTap() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/tap.wav'));
    } catch (_) {}
  }
}
