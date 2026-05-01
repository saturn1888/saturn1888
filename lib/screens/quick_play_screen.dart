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
          title: Text('Quick Play', style: AppTheme.heading(size: 20)),
          actions: const [MuteButton()],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⚡ Pick a Hunt & Start Playing!',
                      style: AppTheme.heading(size: 20)),
                  const SizedBox(height: 4),
                  Text('No setup needed!',
                      style: AppTheme.caption(size: 13)),
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
                  return _HuntCard(hunt: hunt, theme: theme);
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

  const _HuntCard({required this.hunt, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/play', arguments: hunt),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.backgroundColor,
              Color.lerp(theme.backgroundColor, AppTheme.surfaceBright, 0.3)!,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                Illustrations.themeImage(hunt.theme.name),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) =>
                    Text(theme.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hunt.name,
                      style: AppTheme.heading(
                          size: 15, color: theme.accentColor)),
                  Text(
                    theme.description,
                    style: AppTheme.caption(
                        size: 11,
                        color: theme.accentColor.withOpacity(0.6)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${hunt.clues.length} clues • ${hunt.timerMinutes != null ? "${hunt.timerMinutes} min" : "Free play"}',
                    style: AppTheme.caption(
                        size: 10,
                        color: theme.accentColor.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: AppTheme.primary, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
