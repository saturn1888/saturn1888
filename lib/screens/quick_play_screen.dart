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
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF8B6B4A).withOpacity(0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              // Theme header — rich coloured banner
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  // Subtle wood grain effect via gradient
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.backgroundColor,
                      Color.lerp(theme.backgroundColor, Colors.black, 0.08)!,
                      theme.backgroundColor,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Text(theme.emoji, style: const TextStyle(fontSize: 34)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hunt.name,
                            style: AppTheme.heading(
                                size: 19, color: theme.accentColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            theme.description,
                            style: AppTheme.caption(
                                size: 12,
                                color: theme.accentColor.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.accentColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow_rounded,
                          color: theme.accentColor, size: 28),
                    ),
                  ],
                ),
              ),
              // Details bar — parchment coloured
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: const Color(0xFFF5EDE0),
                child: Row(
                  children: [
                    Icon(Icons.help_outline,
                        size: 14, color: AppTheme.leather),
                    const SizedBox(width: 4),
                    Text('${hunt.clues.length} clues',
                        style: AppTheme.caption(
                            size: 12, color: AppTheme.warmBrown)),
                    const SizedBox(width: 16),
                    Icon(Icons.timer_outlined,
                        size: 14, color: AppTheme.leather),
                    const SizedBox(width: 4),
                    Text(
                      hunt.timerMinutes != null
                          ? '${hunt.timerMinutes} min'
                          : 'No timer',
                      style: AppTheme.caption(
                          size: 12, color: AppTheme.warmBrown),
                    ),
                    const Spacer(),
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
      ),
    );
  }
}
