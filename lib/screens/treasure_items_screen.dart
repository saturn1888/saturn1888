import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treasure_item.dart';
import '../models/clue.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class TreasureItemsScreen extends StatefulWidget {
  const TreasureItemsScreen({super.key});

  @override
  State<TreasureItemsScreen> createState() => _TreasureItemsScreenState();
}

class _TreasureItemsScreenState extends State<TreasureItemsScreen> {
  final List<TreasureItem> _items = [];
  final _picker = ImagePicker();
  bool _initialized = false;

  late String _huntName;
  late HuntThemeType _themeType;
  late int? _timerMinutes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _huntName = args['name'] as String;
      _themeType = args['theme'] as HuntThemeType;
      _timerMinutes = args['timer'] as int?;
      _initialized = true;
    }
  }

  void _addItem() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Treasure Item', style: AppTheme.heading(size: 20)),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'e.g. Golden coin, sticker...',
          ),
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                setState(() => _items.add(TreasureItem(name: name)));
              }
              Navigator.pop(ctx);
            },
            child: Text('Add', style: TextStyle(color: AppTheme.darkGold)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickItemPhoto(int index, ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _items[index].photoPath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _showPhotoOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickItemPhoto(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickItemPhoto(index, ImageSource.gallery);
              },
            ),
            if (_items[index].photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _items[index].photoPath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _addClueToItem(int itemIndex) {
    final clueController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Clue', style: AppTheme.heading(size: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'For: ${_items[itemIndex].name}',
              style: AppTheme.body(size: 13, color: AppTheme.leather),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: clueController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Write a riddle or clue...',
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = clueController.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _items[itemIndex].clues.add(Clue(
                    text: text,
                    order: _items[itemIndex].clues.length,
                  ));
                });
              }
              Navigator.pop(ctx);
            },
            child: Text('Add', style: TextStyle(color: AppTheme.darkGold)),
          ),
        ],
      ),
    );
  }

  void _editClue(int itemIndex, int clueIndex) {
    final clue = _items[itemIndex].clues[clueIndex];
    final controller = TextEditingController(text: clue.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Clue', style: AppTheme.heading(size: 20)),
        content: TextField(
          controller: controller,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _items[itemIndex].clues.removeAt(clueIndex));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() => _items[itemIndex].clues[clueIndex].text = text);
              }
              Navigator.pop(ctx);
            },
            child: Text('Save', style: TextStyle(color: AppTheme.darkGold)),
          ),
        ],
      ),
    );
  }

  void _addClueFromLibrary(int itemIndex) async {
    final result = await Navigator.pushNamed(context, '/clue-library');
    if (result != null && result is List<String>) {
      setState(() {
        for (final text in result) {
          _items[itemIndex].clues.add(Clue(
            text: text,
            order: _items[itemIndex].clues.length,
          ));
        }
      });
    }
  }

  bool get _isValid {
    if (_items.isEmpty) return true; // skip is valid
    // At least one item must have at least one clue
    return _items.any((item) => item.clues.isNotEmpty);
  }

  int get _totalClues =>
      _items.fold(0, (sum, item) => sum + item.clues.length);

  void _goToReview() {
    // Flatten all clues from all items for the hunt
    final allClues = <Clue>[];
    for (final item in _items) {
      for (int i = 0; i < item.clues.length; i++) {
        item.clues[i].order = allClues.length;
        allClues.add(item.clues[i]);
      }
    }

    Navigator.pushNamed(
      context,
      '/review',
      arguments: {
        'name': _huntName,
        'theme': _themeType,
        'timer': _timerMinutes,
        'clues': allClues,
        'treasureItems': _items,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Build Your Hunt'),
          actions: const [MuteButton()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addItem,
          child: const Icon(Icons.add, size: 28),
        ),
        body: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text('Add your treasure items',
                      style: AppTheme.heading(size: 20)),
                  const SizedBox(height: 4),
                  Text(
                    'For each item, add a photo and one or more clues\nthat lead hunters to find it.',
                    style: AppTheme.body(size: 13, color: AppTheme.leather),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Items list
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎁',
                              style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          Text(
                            'No treasure items yet!\nTap + to add what hunters will find.',
                            style: AppTheme.body(
                                size: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 4),
                      itemCount: _items.length,
                      itemBuilder: (context, index) =>
                          _buildItemCard(index),
                    ),
            ),
            // Bottom bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${_items.length} item${_items.length == 1 ? '' : 's'} • $_totalClues clue${_totalClues == 1 ? '' : 's'}',
                        style: AppTheme.body(
                            size: 13, color: AppTheme.leather),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _items.isEmpty
                          ? () {
                              // No items — go to standalone clue builder
                              Navigator.pushNamed(
                                context,
                                '/clue-builder',
                                arguments: {
                                  'name': _huntName,
                                  'theme': _themeType,
                                  'timer': _timerMinutes,
                                  'treasureItems': <TreasureItem>[],
                                },
                              );
                            }
                          : _totalClues >= 2
                              ? _goToReview
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: AppTheme.warmBrown,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        _items.isEmpty
                            ? 'Skip — Add Clues Only'
                            : 'Next — Review →',
                        style: AppTheme.heading(
                            size: 18, color: AppTheme.warmBrown),
                      ),
                    ),
                  ),
                  if (_items.isNotEmpty && _totalClues < 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Add at least 2 clues total to continue',
                        style: AppTheme.body(
                            size: 12, color: Colors.orange[700]),
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

  Widget _buildItemCard(int index) {
    final item = _items[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item header: photo + name + delete
            Row(
              children: [
                // Photo
                GestureDetector(
                  onTap: () => _showPhotoOptions(index),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE0D0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppTheme.leather.withOpacity(0.3)),
                    ),
                    child: item.photoPath != null &&
                            File(item.photoPath!).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(item.photoPath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo,
                                  color:
                                      AppTheme.leather.withOpacity(0.5),
                                  size: 22),
                              const SizedBox(height: 2),
                              Text('Photo',
                                  style: AppTheme.body(
                                      size: 9, color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                // Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: AppTheme.heading(size: 18)),
                      Text(
                        '${item.clues.length} clue${item.clues.length == 1 ? '' : 's'}',
                        style: AppTheme.body(
                          size: 12,
                          color: item.clues.isEmpty
                              ? Colors.orange
                              : AppTheme.adventureGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete item
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Item?'),
                        content: Text(
                            'Delete "${item.name}" and all its clues?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _items.removeAt(index));
                              Navigator.pop(ctx);
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete_outline,
                      color: Colors.red[400], size: 22),
                ),
              ],
            ),
            // Clues list
            if (item.clues.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...List.generate(item.clues.length, (ci) {
                final clue = item.clues[ci];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: GestureDetector(
                    onTap: () => _editClue(index, ci),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundColor: AppTheme.darkGold,
                          child: Text('${ci + 1}',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            clue.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.body(size: 13),
                          ),
                        ),
                        Icon(Icons.edit,
                            size: 14,
                            color: Colors.grey.withOpacity(0.5)),
                      ],
                    ),
                  ),
                );
              }),
            ],
            // Add clue buttons
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addClueToItem(index),
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('Add Clue',
                        style: AppTheme.body(
                            size: 13, color: AppTheme.darkGold)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      side: BorderSide(
                          color: AppTheme.darkGold.withOpacity(0.4)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addClueFromLibrary(index),
                    icon: const Text('📚', style: TextStyle(fontSize: 14)),
                    label: Text('From Library',
                        style: AppTheme.body(
                            size: 13, color: AppTheme.darkGold)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      side: BorderSide(
                          color: AppTheme.darkGold.withOpacity(0.4)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
