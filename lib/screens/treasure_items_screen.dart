import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treasure_item.dart';
import '../models/clue.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class TreasureItemsScreen extends StatefulWidget {
  const TreasureItemsScreen({super.key});

  @override
  State<TreasureItemsScreen> createState() => _TreasureItemsScreenState();
}

class _TreasureItemsScreenState extends State<TreasureItemsScreen> {
  List<TreasureItem> _items = [];
  List<Clue> _clues = [];
  bool _initialized = false;
  final _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _items = List<TreasureItem>.from(
          (args['treasureItems'] as List<TreasureItem>?) ?? []);
      _clues = args['clues'] as List<Clue>;
      _initialized = true;
    }
  }

  void _addItem() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Treasure Item', style: AppTheme.heading(size: 20)),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'e.g. Golden coin, sticker, puzzle piece...',
          ),
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _items.add(TreasureItem(name: name));
                });
              }
              Navigator.pop(context);
            },
            child: Text('Add',
                style: TextStyle(color: AppTheme.darkGold)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto(int index, ImageSource source) async {
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
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(index, ImageSource.gallery);
              },
            ),
            if (_items[index].photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _items[index].photoPath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _assignClue(int itemIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign to Clue', style: AppTheme.heading(size: 20)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text('No clue assigned',
                    style: AppTheme.body(size: 15, color: Colors.grey)),
                leading: const Icon(Icons.clear),
                onTap: () {
                  setState(
                      () => _items[itemIndex].assignedClueIndex = null);
                  Navigator.pop(context);
                },
              ),
              ...List.generate(_clues.length, (i) {
                final clue = _clues[i];
                final isAssigned =
                    _items[itemIndex].assignedClueIndex == i;
                return ListTile(
                  title: Text(
                    'Clue ${i + 1}: ${clue.text.split('\n').first}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.body(size: 14),
                  ),
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        isAssigned ? AppTheme.darkGold : Colors.grey[300],
                    child: Text('${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isAssigned ? Colors.white : Colors.black54,
                        )),
                  ),
                  trailing:
                      isAssigned ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    setState(
                        () => _items[itemIndex].assignedClueIndex = i);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Treasure Items'),
          actions: const [MuteButton()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addItem,
          child: const Icon(Icons.add, size: 28),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: AppTheme.darkGold.withOpacity(0.1),
              child: Text(
                'Add the items hunters will find at each clue location.\nYou can assign each item to a specific clue.',
                style: AppTheme.body(size: 13, color: AppTheme.leather),
                textAlign: TextAlign.center,
              ),
            ),
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
                            'No treasure items yet!\nTap + to add items hunters will find.',
                            style: AppTheme.body(
                                size: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                          bottom: 80, top: 8),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final hasClue =
                            item.assignedClueIndex != null &&
                                item.assignedClueIndex! < _clues.length;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Photo
                                GestureDetector(
                                  onTap: () => _showPhotoOptions(index),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppTheme.leather
                                              .withOpacity(0.3)),
                                    ),
                                    child: item.photoPath != null &&
                                            File(item.photoPath!)
                                                .existsSync()
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(item.photoPath!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.add_a_photo,
                                            color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Name and clue assignment
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name,
                                          style: AppTheme.heading(
                                              size: 16)),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () =>
                                            _assignClue(index),
                                        child: Row(
                                          children: [
                                            Icon(
                                              hasClue
                                                  ? Icons.link
                                                  : Icons.link_off,
                                              size: 14,
                                              color: hasClue
                                                  ? AppTheme.darkGold
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              hasClue
                                                  ? 'Clue ${item.assignedClueIndex! + 1}'
                                                  : 'Tap to assign clue',
                                              style: AppTheme.body(
                                                size: 12,
                                                color: hasClue
                                                    ? AppTheme.darkGold
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Delete
                                IconButton(
                                  onPressed: () {
                                    setState(
                                        () => _items.removeAt(index));
                                  },
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red[400]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Done button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _items),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: AppTheme.warmBrown,
                  ),
                  child: Text(
                    _items.isEmpty ? 'Skip' : 'Done (${_items.length} items)',
                    style: AppTheme.heading(
                        size: 18, color: AppTheme.warmBrown),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
