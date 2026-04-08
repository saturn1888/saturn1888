import 'package:flutter/material.dart';
import '../data/premade_hunts.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';
import '../widgets/adventure_widgets.dart';

class QuickPlayScreen extends StatelessWidget {
  const QuickPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hunts = PremadeHunts.all;

    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Play'),
          actions: const [MuteButton()],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AdventureHeader(title: 'Ready-to-Play Hunts', emoji: '🗺️'),
                  const SizedBox(height: 4),
                  Text(
                    'No setup needed! Just pick a hunt and start playing.\nSolve the riddles to find everyday objects.',
                    style: AppTheme.caption(size: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: hunts.length,
                itemBuilder: (context, index) {
                  final hunt = hunts[index];
                  final theme = HuntThemeData.fromType(hunt.themeType);
                  return _HuntCard(
                    hunt: hunt,
                    theme: theme,
                    onPlay: () {
                      Navigator.pushNamed(
                        context,
                        '/play',
                        arguments: hunt,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HuntCard extends StatelessWidget {
  final Hunt hunt;
  final HuntThemeData theme;
  final VoidCallback onPlay;

  const _HuntCard({
    required this.hunt,
    required this.theme,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPlay,
        child: Column(
          children: [
            // Theme header strip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: theme.backgroundColor,
              child: Row(
                children: [
                  Text(theme.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hunt.name,
                          style: AppTheme.heading(
                              size: 18, color: theme.accentColor),
                        ),
                        Text(
                          theme.description,
                          style: AppTheme.caption(
                              size: 12,
                              color: theme.accentColor.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.play_circle_fill,
                      color: theme.accentColor, size: 36),
                ],
              ),
            ),
            // Hunt details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _detailChip(Icons.help_outline,
                      '${hunt.clues.length} clues'),
                  const SizedBox(width: 12),
                  _detailChip(
                    Icons.timer,
                    hunt.timerMinutes != null
                        ? '${hunt.timerMinutes} min'
                        : 'No timer',
                  ),
                  const Spacer(),
                  // Decorative emojis
                  Row(
                    children: theme.decorativeEmojis
                        .take(3)
                        .map((e) => Text(e,
                            style: const TextStyle(fontSize: 16)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.subtleGrey),
        const SizedBox(width: 4),
        Text(label, style: AppTheme.caption(size: 12)),
      ],
    );
  }
}
