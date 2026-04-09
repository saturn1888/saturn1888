import 'package:flutter/material.dart';
import 'music_controller.dart';

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
            muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            size: 22,
            color: Colors.white.withOpacity(0.7),
          ),
          tooltip: muted ? 'Unmute music' : 'Mute music',
        );
      },
    );
  }
}
