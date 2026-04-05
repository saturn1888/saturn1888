import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trophy.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';

class TrophyCabinetScreen extends StatelessWidget {
  const TrophyCabinetScreen({super.key});

  String _milestoneMessage(int count) {
    if (count >= 25) return 'Master Explorer! 25+ hunts completed!';
    if (count >= 10) return 'Trophy Champion! 10+ hunts completed!';
    if (count >= 5) return 'Rising Star! 5+ hunts completed!';
    if (count >= 1) return 'First hunt completed!';
    return '';
  }

  String _milestoneEmoji(int count) {
    if (count >= 25) return '🗺️';
    if (count >= 10) return '🏆';
    if (count >= 5) return '🌟';
    if (count >= 1) return '🎉';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(
        title: const Text('Trophy Cabinet'),
        actions: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Trophy>('trophies').listenable(),
            builder: (context, Box<Trophy> box, _) {
              if (box.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () => _showClearAllDialog(context, box),
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear all trophies',
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Trophy>('trophies').listenable(),
        builder: (context, Box<Trophy> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'No trophies yet!\nComplete a hunt to earn your first trophy.',
                    style: AppTheme.body(size: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final trophies = box.values.toList().reversed.toList();
          final milestone = _milestoneMessage(trophies.length);
          final emoji = _milestoneEmoji(trophies.length);

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppTheme.gold.withOpacity(0.15),
                child: Column(
                  children: [
                    Text(
                      '${trophies.length} Hunt${trophies.length == 1 ? '' : 's'} Completed',
                      style: AppTheme.heading(size: 22),
                    ),
                    if (milestone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$emoji $milestone',
                        style:
                            AppTheme.body(size: 14, color: AppTheme.darkGold),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: trophies.length,
                  itemBuilder: (context, index) {
                    final trophy = trophies[index];
                    final theme = HuntThemeData.fromType(trophy.themeType);
                    return GestureDetector(
                      onTap: () => _showTrophyDetail(context, trophy),
                      onLongPress: () => _showDeleteTrophy(context, trophy),
                      child: Card(
                        color: theme.backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(theme.emoji,
                                  style: const TextStyle(fontSize: 40)),
                              const SizedBox(height: 8),
                              Text(
                                trophy.huntName,
                                style: AppTheme.heading(
                                  size: 14,
                                  color: theme.accentColor,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trophy.timeFormatted,
                                style: AppTheme.body(
                                  size: 13,
                                  color: theme.accentColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(trophy.completedAt),
                                style: AppTheme.body(
                                  size: 11,
                                  color: theme.accentColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteTrophy(BuildContext context, Trophy trophy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Trophy?', style: AppTheme.heading(size: 22)),
        content: Text(
          'Remove "${trophy.huntName}" from your trophy cabinet?',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              trophy.delete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, Box<Trophy> box) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Trophies?', style: AppTheme.heading(size: 22)),
        content: Text(
          'This will remove all ${box.length} trophies. This cannot be undone.',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              box.clear();
              Navigator.pop(context);
            },
            child: const Text('Clear All',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTrophyDetail(BuildContext context, Trophy trophy) {
    final theme = HuntThemeData.fromType(trophy.themeType);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(theme.emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(
              trophy.huntName,
              style: AppTheme.heading(size: 22, color: theme.accentColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _detailRow('Theme', theme.name, theme.accentColor),
            _detailRow('Clues', '${trophy.clueCount}', theme.accentColor),
            _detailRow('Time', trophy.timeFormatted, theme.accentColor),
            _detailRow(
                'Date', _formatDate(trophy.completedAt), theme.accentColor),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteTrophy(context, trophy);
            },
            child: Text('Delete',
                style: AppTheme.body(size: 14, color: Colors.red[300])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: AppTheme.body(size: 16, color: theme.accentColor)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTheme.body(size: 14, color: color.withOpacity(0.7))),
          Text(value, style: AppTheme.body(size: 14, color: color)),
        ],
      ),
    );
  }
}
