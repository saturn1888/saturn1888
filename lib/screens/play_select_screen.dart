import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';

class PlaySelectScreen extends StatelessWidget {
  const PlaySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(title: const Text('Choose a Hunt')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Hunt>('hunts').listenable(),
        builder: (context, Box<Hunt> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🗺️', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'No hunts created yet!\nGo back and create one first.',
                    style: AppTheme.body(size: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final hunts = box.values.toList().reversed.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hunts.length,
            itemBuilder: (context, index) {
              final hunt = hunts[index];
              final theme = HuntThemeData.fromType(hunt.themeType);
              return Dismissible(
                key: ValueKey(hunt.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 32),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Hunt?', style: AppTheme.heading(size: 22)),
                      content: Text(
                        'Delete "${hunt.name}"? This cannot be undone.',
                        style: AppTheme.body(size: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ) ?? false;
                },
                onDismissed: (_) {
                  final name = hunt.name;
                  hunt.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name deleted'),
                      backgroundColor: Colors.red[700],
                    ),
                  );
                },
                child: Card(
                  color: theme.backgroundColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Text(theme.emoji,
                        style: const TextStyle(fontSize: 36)),
                    title: Text(
                      hunt.name,
                      style: AppTheme.heading(
                        size: 18,
                        color: theme.accentColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${hunt.clues.length} clues • ${hunt.timerMinutes != null ? '${hunt.timerMinutes} min' : 'No timer'}',
                          style: AppTheme.body(
                            size: 13,
                            color: theme.accentColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Swipe left to delete',
                          style: AppTheme.body(
                            size: 11,
                            color: theme.accentColor.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.play_arrow,
                        color: theme.accentColor, size: 32),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/play',
                        arguments: hunt,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    ));
  }
}
