import 'package:flutter/material.dart';
import '../data/illustrations.dart';
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
          gradient: const LinearGradient(
            colors: [Color(0xFF2E3590), Color(0xFF252B7A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
                    Image.asset(Illustrations.themeImage(hunt.theme.name),
                        width: 48,
                        height: 48,
                        errorBuilder: (_, __, ___) =>
                            Text(theme.emoji, style: const TextStyle(fontSize: 34))),
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
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ),
              // Details bar
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.black.withOpacity(0.15),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        Illustrations.themeImage(hunt.theme.name),
                        width: 20, height: 20,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (_, __, ___) =>
                            Text(theme.emoji, style: const TextStyle(fontSize: 16)),
                      ),
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
