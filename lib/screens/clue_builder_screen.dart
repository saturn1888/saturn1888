import 'package:flutter/material.dart';
import '../models/clue.dart';
import '../models/hunt_theme.dart';
import '../models/treasure_item.dart';
import '../theme/app_theme.dart';
import 'dart:io';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class ClueBuilderScreen extends StatefulWidget {
  const ClueBuilderScreen({super.key});

  @override
  State<ClueBuilderScreen> createState() => _ClueBuilderScreenState();
}

class _ClueBuilderScreenState extends State<ClueBuilderScreen> {
  List<Clue> _clues = [];
  late String _huntName;
  late HuntThemeType _themeType;
  late int? _timerMinutes;
  String? _prizeDescription;
  String? _prizePhotoPath;
  List<TreasureItem> _treasureItems = [];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _huntName = args['name'] as String;
      _themeType = args['theme'] as HuntThemeType;
      _timerMinutes = args['timer'] as int?;
      _prizeDescription = args['prizeDescription'] as String?;
      _prizePhotoPath = args['prizePhotoPath'] as String?;
      _treasureItems = List<TreasureItem>.from(
          (args['treasureItems'] as List<TreasureItem>?) ?? []);
      _timerMinutes = args['timer'] as int?;
      _initialized = true;
    }
  }

  void _addClue(Clue clue) {
    setState(() {
      clue.order = _clues.length;
      _clues.add(clue);
    });
  }

  void _editClue(int index, Clue clue) {
    setState(() {
      _clues[index] = clue;
    });
  }

  void _deleteClue(int index) {
    setState(() {
      _clues.removeAt(index);
      for (int i = 0; i < _clues.length; i++) {
        _clues[i].order = i;
      }
    });
  }

  Future<void> _openClueEditor({Clue? existingClue, int? index}) async {
    final result = await Navigator.pushNamed(
      context,
      '/clue-editor',
      arguments: existingClue,
    );
    if (result != null) {
      if (result == 'delete' && index != null) {
        _deleteClue(index);
      } else if (result is Clue) {
        if (index != null) {
          _editClue(index, result);
        } else {
          _addClue(result);
        }
      }
    }
  }

  Future<void> _openClueLibrary() async {
    final result = await Navigator.pushNamed(context, '/clue-library');
    if (result != null && result is List<String>) {
      for (final text in result) {
        _addClue(Clue(text: text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasWarning = _clues.length < 2 || _clues.length > 10;

    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(title: const Text('Build Clues'), actions: [const MuteButton()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openClueEditor(),
        child: const Icon(Icons.add, size: 32),
      ),
      body: Column(
        children: [
          if (hasWarning && _clues.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: _clues.length < 2
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              child: Text(
                _clues.length < 2
                    ? '⚠️ Add at least 2 clues to start a hunt'
                    : '⚠️ Maximum 10 clues recommended',
                style: AppTheme.body(
                  size: 14,
                  color: _clues.length < 2 ? Colors.orange[800] : Colors.red[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: _openClueLibrary,
              icon: const Text('📚', style: TextStyle(fontSize: 20)),
              label: Text(
                'Browse Clue Library',
                style: AppTheme.body(size: 16, color: AppTheme.darkGold),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppTheme.darkGold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/treasure-items',
                  arguments: {
                    'treasureItems': _treasureItems,
                    'clues': _clues,
                  },
                );
                if (result != null && result is List<TreasureItem>) {
                  setState(() => _treasureItems = result);
                }
              },
              icon: const Text('🎁', style: TextStyle(fontSize: 20)),
              label: Text(
                _treasureItems.isEmpty
                    ? 'Add Treasure Items'
                    : 'Treasure Items (${_treasureItems.length})',
                style: AppTheme.body(size: 16, color: AppTheme.darkGold),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppTheme.darkGold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _clues.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        Text(
                          'No clues yet!\nTap + to add your first clue',
                          style: AppTheme.body(size: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _clues.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final clue = _clues.removeAt(oldIndex);
                        _clues.insert(newIndex, clue);
                        for (int i = 0; i < _clues.length; i++) {
                          _clues[i].order = i;
                        }
                      });
                    },
                    itemBuilder: (context, index) {
                      final clue = _clues[index];
                      return Card(
                        key: ValueKey('clue_$index'),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.gold,
                            child: Text(
                              '${index + 1}',
                              style: AppTheme.heading(
                                size: 16,
                                color: AppTheme.warmBrown,
                              ),
                            ),
                          ),
                          title: Text(
                            clue.text.split('\n').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.body(size: 15),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (clue.photoPath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: _buildPhotoThumbnail(clue.photoPath!),
                                ),
                              const SizedBox(width: 8),
                              const Icon(Icons.drag_handle),
                            ],
                          ),
                          onTap: () => _openClueEditor(
                            existingClue: clue,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clues.length >= 2
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/review',
                          arguments: {
                            'name': _huntName,
                            'theme': _themeType,
                            'timer': _timerMinutes,
                            'clues': _clues,
                            'prizeDescription': _prizeDescription,
                            'prizePhotoPath': _prizePhotoPath,
                            'treasureItems': _treasureItems,
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  foregroundColor: AppTheme.warmBrown,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Next →',
                  style: AppTheme.heading(size: 20, color: AppTheme.warmBrown),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildPhotoThumbnail(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }
    return Container(
      width: 40,
      height: 40,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 20),
    );
  }
}
