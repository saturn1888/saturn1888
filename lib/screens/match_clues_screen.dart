import 'dart:io';
import 'package:flutter/material.dart';
import '../models/clue.dart';
import '../models/hunt_theme.dart';
import '../models/treasure_item.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class MatchCluesScreen extends StatefulWidget {
  const MatchCluesScreen({super.key});

  @override
  State<MatchCluesScreen> createState() => _MatchCluesScreenState();
}

class _MatchCluesScreenState extends State<MatchCluesScreen> {
  late String _huntName;
  late HuntThemeType _themeType;
  late int? _timerMinutes;
  late List<Clue> _clues;
  late List<TreasureItem> _treasureItems;
  bool _initialized = false;

  // Which treasure item is currently selected for matching
  int? _selectedItemIndex;

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
      _treasureItems = args['treasureItems'] as List<TreasureItem>;
      _initialized = true;
    }
  }

  // Get which treasure item is assigned to a clue index
  TreasureItem? _itemForClue(int clueIndex) {
    for (final item in _treasureItems) {
      if (item.assignedClueIndex == clueIndex) return item;
    }
    return null;
  }

  // Get which clue index a treasure item is assigned to
  int? _clueForItem(int itemIndex) {
    return _treasureItems[itemIndex].assignedClueIndex;
  }

  void _onClueTap(int clueIndex) {
    if (_selectedItemIndex == null) return;

    setState(() {
      final item = _treasureItems[_selectedItemIndex!];
      // If this clue already has this item, unassign
      if (item.assignedClueIndex == clueIndex) {
        item.assignedClueIndex = null;
      } else {
        // Unassign any other item from this clue
        for (final other in _treasureItems) {
          if (other.assignedClueIndex == clueIndex) {
            other.assignedClueIndex = null;
          }
        }
        item.assignedClueIndex = clueIndex;
      }
      _selectedItemIndex = null;
    });
  }

  void _autoMatch() {
    setState(() {
      // Simple auto-match: assign items to clues in order
      for (int i = 0; i < _treasureItems.length && i < _clues.length; i++) {
        _treasureItems[i].assignedClueIndex = i;
      }
    });
  }

  void _clearAll() {
    setState(() {
      for (final item in _treasureItems) {
        item.assignedClueIndex = null;
      }
    });
  }

  void _goToReview() {
    Navigator.pushNamed(
      context,
      '/review',
      arguments: {
        'name': _huntName,
        'theme': _themeType,
        'timer': _timerMinutes,
        'clues': _clues,
        'treasureItems': _treasureItems,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final unmatched =
        _treasureItems.where((i) => i.assignedClueIndex == null).length;

    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Match Items to Clues'),
          actions: const [MuteButton()],
        ),
        body: Column(
          children: [
            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: AppTheme.warmBrown.withOpacity(0.08),
              child: Column(
                children: [
                  Text('Pair each treasure with a clue',
                      style: AppTheme.heading(size: 18)),
                  const SizedBox(height: 4),
                  Text(
                    'Tap a treasure item, then tap the clue where it\'s hidden.',
                    style: AppTheme.body(size: 13, color: AppTheme.leather),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _autoMatch,
                        icon: const Icon(Icons.auto_fix_high, size: 16),
                        label: Text('Auto-match',
                            style: AppTheme.body(
                                size: 13, color: AppTheme.darkGold)),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _clearAll,
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: Text('Clear all',
                            style:
                                AppTheme.body(size: 13, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Treasure items (horizontal scroll)
            Container(
              height: 110,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _treasureItems.length,
                itemBuilder: (context, index) {
                  final item = _treasureItems[index];
                  final isSelected = _selectedItemIndex == index;
                  final isMatched = item.assignedClueIndex != null;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItemIndex =
                            isSelected ? null : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 85,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.gold.withOpacity(0.3)
                            : isMatched
                                ? AppTheme.adventureGreen.withOpacity(0.15)
                                : const Color(0xFFF5EDE0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.gold
                              : isMatched
                                  ? AppTheme.adventureGreen
                                  : AppTheme.leather.withOpacity(0.2),
                          width: isSelected ? 3 : 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Photo or icon
                          if (item.photoPath != null &&
                              File(item.photoPath!).existsSync())
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(item.photoPath!),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Text('🎁',
                                style: TextStyle(
                                    fontSize: isSelected ? 28 : 24)),
                          const SizedBox(height: 4),
                          Text(
                            item.name,
                            style: AppTheme.body(size: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          if (isMatched)
                            Text(
                              'Clue ${item.assignedClueIndex! + 1}',
                              style: AppTheme.body(
                                  size: 9,
                                  color: AppTheme.adventureGreen),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_selectedItemIndex != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'Now tap a clue below to assign "${_treasureItems[_selectedItemIndex!].name}" to it',
                  style: AppTheme.body(size: 13, color: AppTheme.darkGold),
                  textAlign: TextAlign.center,
                ),
              ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppTheme.leather.withOpacity(0.2)),
            ),
            // Clues list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 4),
                itemCount: _clues.length,
                itemBuilder: (context, index) {
                  final clue = _clues[index];
                  final matchedItem = _itemForClue(index);
                  final isTarget = _selectedItemIndex != null;

                  return GestureDetector(
                    onTap: isTarget ? () => _onClueTap(index) : null,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      color: isTarget
                          ? const Color(0xFFFFF8E8)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: matchedItem != null
                              ? AppTheme.adventureGreen
                              : isTarget
                                  ? AppTheme.gold
                                  : Colors.transparent,
                          width: matchedItem != null ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: matchedItem != null
                                  ? AppTheme.adventureGreen
                                  : AppTheme.gold,
                              child: Text(
                                '${index + 1}',
                                style: AppTheme.heading(
                                    size: 14,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clue.text.split('\n').first,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.body(size: 14),
                                  ),
                                  if (matchedItem != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4),
                                      child: Row(
                                        children: [
                                          Icon(Icons.link,
                                              size: 14,
                                              color: AppTheme
                                                  .adventureGreen),
                                          const SizedBox(width: 4),
                                          if (matchedItem.photoPath !=
                                                  null &&
                                              File(matchedItem
                                                      .photoPath!)
                                                  .existsSync())
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      4),
                                              child: Image.file(
                                                File(matchedItem
                                                    .photoPath!),
                                                width: 18,
                                                height: 18,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          const SizedBox(width: 4),
                                          Text(
                                            matchedItem.name,
                                            style: AppTheme.body(
                                                size: 12,
                                                color: AppTheme
                                                    .adventureGreen),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (isTarget)
                              Icon(
                                matchedItem != null
                                    ? Icons.swap_horiz
                                    : Icons.add_circle_outline,
                                color: AppTheme.gold,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (unmatched > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '$unmatched item${unmatched == 1 ? '' : 's'} not yet matched',
                        style: AppTheme.body(
                            size: 13, color: Colors.orange[700]),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: AppTheme.warmBrown,
                      ),
                      child: Text(
                        'Next — Review →',
                        style: AppTheme.heading(
                            size: 18, color: AppTheme.warmBrown),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
