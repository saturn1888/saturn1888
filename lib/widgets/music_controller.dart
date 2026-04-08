import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Global music controller — singleton so music persists across screens.
/// Pauses when app is backgrounded, resumes when foregrounded.
class MusicController extends ChangeNotifier with WidgetsBindingObserver {
  static final MusicController _instance = MusicController._();
  static MusicController get instance => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;
  bool _started = false;

  MusicController._() {
    WidgetsBinding.instance.addObserver(this);
  }

  bool get isMuted => _isMuted;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _player.pause();
    } else if (state == AppLifecycleState.resumed && !_isMuted && _started) {
      _player.resume();
    }
  }

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
}
