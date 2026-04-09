import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/illustrations.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class ManageHuntsScreen extends StatelessWidget {
  const ManageHuntsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(
        title: const Text('Manage Hunts'),
        actions: [
          const MuteButton(),
          ValueListenableBuilder(
            valueListenable: Hive.box<Hunt>('hunts').listenable(),
            builder: (context, Box<Hunt> box, _) {
              if (box.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () => _showClearAllDialog(context, box),
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Delete all hunts',
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Hunt>('hunts').listenable(),
        builder: (context, Box<Hunt> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Illustrations.emptyNoHunts,
                      width: 120,
                      height: 120,
                      errorBuilder: (_, __, ___) =>
                          const Text('📋', style: TextStyle(fontSize: 64))),
                  const SizedBox(height: 16),
                  Text(
                    'No saved hunts.\nCreate a hunt to get started!',
                    style: AppTheme.body(size: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/setup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: AppTheme.warmBrown,
                    ),
                    child: Text('Create a Hunt',
                        style: AppTheme.heading(
                            size: 18, color: AppTheme.warmBrown)),
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
                  child: const Icon(Icons.delete,
                      color: Colors.white, size: 32),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Hunt?',
                          style: AppTheme.heading(size: 22)),
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
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ) ??
                      false;
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
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                      '${hunt.clues.length} clues • ${theme.name}',
                      style: AppTheme.body(
                        size: 13,
                        color: theme.accentColor.withOpacity(0.7),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/share-hunt',
                              arguments: hunt,
                            );
                          },
                          icon: Icon(Icons.share,
                              color: theme.accentColor.withOpacity(0.7),
                              size: 22),
                          tooltip: 'Share hunt code',
                        ),
                        IconButton(
                          onPressed: () => _showDeleteDialog(context, hunt),
                          icon: Icon(Icons.delete_outline,
                              color: theme.accentColor.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ));
  }

  void _showDeleteDialog(BuildContext context, Hunt hunt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Hunt?', style: AppTheme.heading(size: 22)),
        content: Text(
          'Delete "${hunt.name}"? This cannot be undone.',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              hunt.delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${hunt.name} deleted'),
                  backgroundColor: Colors.red[700],
                ),
              );
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, Box<Hunt> box) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Delete All Hunts?', style: AppTheme.heading(size: 22)),
        content: Text(
          'This will remove all ${box.length} saved hunts. This cannot be undone.',
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
            child: const Text('Delete All',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
