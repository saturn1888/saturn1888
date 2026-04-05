import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/treasure_item.dart';
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

  // Pass-through args from Hunt Setup
  late String _huntName;
  late dynamic _themeType;
  late int? _timerMinutes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _huntName = args['name'] as String;
      _themeType = args['theme'];
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
            hintText: 'e.g. Golden coin, sticker, puzzle piece...',
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
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(index, ImageSource.gallery);
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

  void _goToClueBuilder() {
    Navigator.pushNamed(
      context,
      '/clue-builder',
      arguments: {
        'name': _huntName,
        'theme': _themeType,
        'timer': _timerMinutes,
        'treasureItems': _items,
      },
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
            // Step indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: AppTheme.warmBrown.withOpacity(0.08),
              child: Row(
                children: [
                  _stepDot('1', 'Setup', true),
                  _stepLine(),
                  _stepDot('2', 'Items', false),
                  _stepLine(),
                  _stepDot('3', 'Clues', false),
                  _stepLine(),
                  _stepDot('4', 'Review', false),
                ],
              ),
            ),
            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text(
                    'What will hunters find?',
                    style: AppTheme.heading(size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add the treasure items hidden at each clue location.\nTap the photo area to add a picture of each item.',
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
                      padding:
                          const EdgeInsets.only(bottom: 80, top: 4),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Photo thumbnail
                                GestureDetector(
                                  onTap: () =>
                                      _showPhotoOptions(index),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE0D0),
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
                                                BorderRadius.circular(
                                                    10),
                                            child: Image.file(
                                              File(item.photoPath!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            children: [
                                              Icon(Icons.add_a_photo,
                                                  color: AppTheme
                                                      .leather
                                                      .withOpacity(
                                                          0.5),
                                                  size: 24),
                                              const SizedBox(
                                                  height: 2),
                                              Text('Add photo',
                                                  style: AppTheme.body(
                                                      size: 9,
                                                      color: Colors
                                                          .grey)),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Item name
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name,
                                          style: AppTheme.heading(
                                              size: 17)),
                                      if (item.photoPath != null)
                                        Text('Photo added',
                                            style: AppTheme.body(
                                                size: 12,
                                                color:
                                                    AppTheme.darkGold)),
                                    ],
                                  ),
                                ),
                                // Delete
                                IconButton(
                                  onPressed: () => setState(
                                      () => _items.removeAt(index)),
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
            // Next button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToClueBuilder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: AppTheme.warmBrown,
                  ),
                  child: Text(
                    _items.isEmpty
                        ? 'Skip — No Treasure Items'
                        : 'Next — Add Clues →',
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

  Widget _stepDot(String number, String label, bool completed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor:
              completed ? AppTheme.darkGold : AppTheme.leather.withOpacity(0.3),
          child: Text(number,
              style: TextStyle(
                  fontSize: 12,
                  color: completed ? Colors.white : AppTheme.warmBrown,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: AppTheme.body(
                size: 10,
                color: completed ? AppTheme.darkGold : Colors.grey)),
      ],
    );
  }

  Widget _stepLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14, left: 4, right: 4),
        color: AppTheme.leather.withOpacity(0.2),
      ),
    );
  }
}
