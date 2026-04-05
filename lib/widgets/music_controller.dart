import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Global music controller — singleton so music persists across screens
class MusicController extends ChangeNotifier {
  static final MusicController _instance = MusicController._();
  static MusicController get instance => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;
  bool _started = false;

  MusicController._();

  bool get isMuted => _isMuted;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.7);
      await _player.play(AssetSource('sounds/adventure_music.wav'));
    } catch (e) {
      // Music file not available
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _player.setVolume(_isMuted ? 0 : 0.7);
    notifyListeners();
  }

  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
