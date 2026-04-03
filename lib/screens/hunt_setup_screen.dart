import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';

class HuntSetupScreen extends StatefulWidget {
  const HuntSetupScreen({super.key});

  @override
  State<HuntSetupScreen> createState() => _HuntSetupScreenState();
}

class _HuntSetupScreenState extends State<HuntSetupScreen> {
  final _nameController = TextEditingController();
  final _prizeController = TextEditingController();
  HuntThemeType _selectedTheme = HuntThemeType.pirate;
  int? _timerMinutes;
  String? _prizePhotoPath;
  final _picker = ImagePicker();

  static const List<int?> _timerOptions = [null, 5, 10, 15, 20, 30];

  @override
  void dispose() {
    _nameController.dispose();
    _prizeController.dispose();
    super.dispose();
  }

  Future<void> _pickPrizePhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _prizePhotoPath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _showPrizePhotoOptions() {
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
                _pickPrizePhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPrizePhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hunt Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hunt Name', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Backyard Adventure',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Text('Choose a Theme', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: HuntThemeData.all.length,
              itemBuilder: (context, index) {
                final theme = HuntThemeData.all[index];
                final isSelected = _selectedTheme == theme.type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTheme = theme.type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected ? theme.accentColor : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.accentColor.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                theme.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                theme.name,
                                style: AppTheme.heading(
                                  size: 14,
                                  color: theme.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.check_circle,
                              color: theme.accentColor,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            Text('What are hunters looking for?',
                style: AppTheme.heading(size: 20)),
            const SizedBox(height: 4),
            Text(
              'Tell hunters what\'s hidden at each clue spot',
              style: AppTheme.body(size: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _prizeController,
              decoration: const InputDecoration(
                hintText: 'e.g. Golden coins, stickers, puzzle pieces...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            if (_prizePhotoPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildPrizePhoto(),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _prizePhotoPath = null),
                icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                label: const Text('Remove photo',
                    style: TextStyle(color: Colors.red, fontSize: 13)),
              ),
            ] else
              OutlinedButton.icon(
                onPressed: _showPrizePhotoOptions,
                icon: const Icon(Icons.add_a_photo, size: 18),
                label: const Text('Add prize photo'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: AppTheme.darkGold.withOpacity(0.5)),
                ),
              ),

            const SizedBox(height: 24),
            Text('Timer', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timerOptions.map((minutes) {
                final isSelected = _timerMinutes == minutes;
                return ChoiceChip(
                  label: Text(
                    minutes == null ? 'Off' : '$minutes min',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.warmBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.darkGold,
                  backgroundColor: Colors.white,
                  onSelected: (_) => setState(() => _timerMinutes = minutes),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a hunt name')),
                    );
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    '/clue-builder',
                    arguments: {
                      'name': name,
                      'theme': _selectedTheme,
                      'timer': _timerMinutes,
                      'prizeDescription':
                          _prizeController.text.trim().isEmpty
                              ? null
                              : _prizeController.text.trim(),
                      'prizePhotoPath': _prizePhotoPath,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  foregroundColor: AppTheme.warmBrown,
                ),
                child: Text('Next →',
                    style: AppTheme.heading(
                        size: 20, color: AppTheme.warmBrown)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizePhoto() {
    final file = File(_prizePhotoPath!);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    }
    return Container(
      width: double.infinity,
      height: 150,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
    );
  }
}
