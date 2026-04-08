import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/clue.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../models/treasure_item.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late TextEditingController _victoryController;
  late String _huntName;
  late HuntThemeType _themeType;
  late int? _timerMinutes;
  late List<Clue> _clues;
  List<TreasureItem> _treasureItems = [];
  bool _initialized = false;
  bool _shuffleClues = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _huntName = args['name'] as String;
      _themeType = args['theme'] as HuntThemeType;
      _timerMinutes = args['timer'] as int?;
      _clues = args['clues'] as List<Clue>;
      _treasureItems = List<TreasureItem>.from(
          (args['treasureItems'] as List<TreasureItem>?) ?? []);
      // Use themed default victory message
      final theme = HuntThemeData.fromType(_themeType);
      _victoryController = TextEditingController(
        text: theme.defaultVictoryMessage,
      );
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _victoryController.dispose();
    super.dispose();
  }

  Hunt _buildHunt() {
    final clues = List<Clue>.from(_clues);
    if (_shuffleClues) clues.shuffle();
    return Hunt(
      id: const Uuid().v4(),
      name: _huntName,
      themeType: _themeType,
      clues: clues,
      timerMinutes: _timerMinutes,
      victoryMessage: _victoryController.text.trim(),
      treasureItems: _treasureItems.isEmpty ? null : _treasureItems,
    );
  }

  Future<Hunt> _saveHunt() async {
    final hunt = _buildHunt();
    final box = Hive.box<Hunt>('hunts');
    await box.put(hunt.id, hunt);
    return hunt;
  }

  Future<void> _startHunt() async {
    final hunt = await _saveHunt();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/play',
        (route) => route.isFirst,
        arguments: hunt,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HuntThemeData.fromType(_themeType);

    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(title: const Text('Review Hunt'), actions: [const MuteButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: theme.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(theme.emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _huntName,
                            style: AppTheme.heading(
                              size: 22,
                              color: theme.accentColor,
                            ),
                          ),
                          Text(
                            '${_clues.length} clues • ${_timerMinutes != null ? '$_timerMinutes min timer' : 'No timer'}',
                            style: AppTheme.body(
                              size: 14,
                              color: theme.accentColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Treasure items summary
            if (_treasureItems.isNotEmpty) ...[
              Text('Treasure Items', style: AppTheme.heading(size: 20)),
              const SizedBox(height: 8),
              ...List.generate(_treasureItems.length, (index) {
                final item = _treasureItems[index];
                final hasClue = item.assignedClueIndex != null &&
                    item.assignedClueIndex! < _clues.length;
                return Card(
                  child: ListTile(
                    leading: const Text('🎁', style: TextStyle(fontSize: 24)),
                    title: Text(item.name, style: AppTheme.body(size: 15)),
                    subtitle: Text(
                      hasClue
                          ? 'Assigned to Clue ${item.assignedClueIndex! + 1}'
                          : 'Not assigned to a clue',
                      style: AppTheme.body(
                        size: 12,
                        color: hasClue ? AppTheme.adventureGreen : Colors.orange,
                      ),
                    ),
                    trailing: item.photoPath != null
                        ? const Icon(Icons.photo, size: 16, color: Colors.grey)
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
            Text('Clues', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            ...List.generate(_clues.length, (index) {
              final clue = _clues[index];
              // Find if any treasure item is assigned to this clue
              final matchedItem = _treasureItems
                  .where((i) => i.assignedClueIndex == index)
                  .toList();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: matchedItem.isNotEmpty
                        ? AppTheme.adventureGreen
                        : AppTheme.gold,
                    radius: 16,
                    child: Text(
                      '${index + 1}',
                      style: AppTheme.heading(size: 14, color: AppTheme.warmBrown),
                    ),
                  ),
                  title: Text(
                    clue.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.body(size: 14),
                  ),
                  subtitle: matchedItem.isNotEmpty
                      ? Text(
                          '🎁 ${matchedItem.map((i) => i.name).join(', ')}',
                          style: AppTheme.body(
                              size: 12, color: AppTheme.adventureGreen),
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (clue.photoPath != null)
                        const Icon(Icons.photo, size: 16, color: Colors.grey),
                      if (clue.wrongAnswerHint != null)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.help_outline,
                              size: 16, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Text('Victory Message', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            TextField(
              controller: _victoryController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Message shown when the hunt is complete!',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('Shuffle clue order', style: AppTheme.body(size: 16)),
              subtitle: Text(
                'Randomise the order for replay variety',
                style: AppTheme.body(size: 13, color: Colors.grey),
              ),
              secondary: const Text('🔀', style: TextStyle(fontSize: 24)),
              value: _shuffleClues,
              activeColor: AppTheme.darkGold,
              onChanged: (v) => setState(() => _shuffleClues = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            // Start hunt button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startHunt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.adventureGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: Text(
                  'Start Hunt 🎯',
                  style: AppTheme.heading(size: 22, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Save & Share button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final hunt = await _saveHunt();
                  if (mounted) {
                    Navigator.pushNamed(
                      context,
                      '/share-hunt',
                      arguments: hunt,
                    );
                  }
                },
                icon: const Icon(Icons.share, size: 20),
                label: Text(
                  'Save & Share Code',
                  style: AppTheme.heading(size: 18, color: AppTheme.warmBrown),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  foregroundColor: AppTheme.warmBrown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Save only button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await _saveHunt();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hunt saved! You can play or share it later.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.leather.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Save for Later',
                  style: AppTheme.body(size: 16, color: AppTheme.warmBrown),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }
}
