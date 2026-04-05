import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/clue.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class ClueEditorScreen extends StatefulWidget {
  const ClueEditorScreen({super.key});

  @override
  State<ClueEditorScreen> createState() => _ClueEditorScreenState();
}

class _ClueEditorScreenState extends State<ClueEditorScreen> {
  final _clueController = TextEditingController();
  final _hintController = TextEditingController();
  String? _photoPath;
  bool _isEditing = false;
  final _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final clue = ModalRoute.of(context)!.settings.arguments as Clue?;
    if (clue != null && !_isEditing) {
      _clueController.text = clue.text;
      _hintController.text = clue.wrongAnswerHint ?? '';
      _photoPath = clue.photoPath;
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _clueController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _photoPath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _showPhotoOptions() {
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
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Clue' : 'New Clue'),
        actions: const [MuteButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clue Text', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            TextField(
              controller: _clueController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your clue or riddle here...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Text('Photo Hint (Optional)', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            if (_photoPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildPhoto(),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _photoPath = null),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
              ),
            ] else
              OutlinedButton.icon(
                onPressed: _showPhotoOptions,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add Photo Hint'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: AppTheme.darkGold.withOpacity(0.5)),
                ),
              ),
            const SizedBox(height: 24),
            Text('Wrong Answer Hint (Optional)',
                style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            TextField(
              controller: _hintController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'A hint shown when hunters need help...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = _clueController.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter clue text')),
                    );
                    return;
                  }
                  final clue = Clue(
                    text: text,
                    photoPath: _photoPath,
                    wrongAnswerHint: _hintController.text.trim().isEmpty
                        ? null
                        : _hintController.text.trim(),
                  );
                  Navigator.pop(context, clue);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.adventureGreen,
                  foregroundColor: Colors.white,
                ),
                child: Text('Save ✅',
                    style: AppTheme.heading(size: 20, color: Colors.white)),
              ),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Clue?'),
                        content: const Text(
                            'Are you sure you want to delete this clue?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context, 'delete');
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Delete Clue 🗑️',
                    style: AppTheme.body(size: 16, color: Colors.red),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }

  Widget _buildPhoto() {
    final file = File(_photoPath!);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Image not found'),
        ],
      ),
    );
  }
}
