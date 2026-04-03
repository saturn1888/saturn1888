import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';

class PlaySelectScreen extends StatelessWidget {
  const PlaySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return Card(
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
                  subtitle: Text(
                    '${hunt.clues.length} clues • ${hunt.timerMinutes != null ? '${hunt.timerMinutes} min' : 'No timer'}',
                    style: AppTheme.body(
                      size: 13,
                      color: theme.accentColor.withOpacity(0.7),
                    ),
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
              );
            },
          );
        },
      ),
    );
  }
}
