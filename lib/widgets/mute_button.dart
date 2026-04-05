import 'package:flutter/material.dart';
import 'music_controller.dart';

/// A small mute/unmute icon for the AppBar leading or actions slot
class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MusicController.instance,
      builder: (context, _) {
        final muted = MusicController.instance.isMuted;
        return IconButton(
          onPressed: () => MusicController.instance.toggleMute(),
          icon: Icon(
            muted ? Icons.volume_off : Icons.volume_up,
            color: const Color(0xFFF5DEB3),
            size: 22,
          ),
          tooltip: muted ? 'Unmute music' : 'Mute music',
        );
      },
    );
  }
}
