import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';

/// Voice clue recorder using platform method channel (Android only)
class VoiceClueRecorder extends StatefulWidget {
  final String? existingPath;
  final ValueChanged<String?> onChanged;

  const VoiceClueRecorder({
    super.key,
    this.existingPath,
    required this.onChanged,
  });

  @override
  State<VoiceClueRecorder> createState() => _VoiceClueRecorderState();
}

class _VoiceClueRecorderState extends State<VoiceClueRecorder> {
  static const _channel = MethodChannel('com.ozhunt.ozhunt/recorder');
  final _player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedPath;
  bool _recorderAvailable = true;

  @override
  void initState() {
    super.initState();
    _recordedPath = widget.existingPath;
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_clues/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await Directory('${dir.path}/voice_clues').create(recursive: true);

      await _channel.invokeMethod('startRecording', {'path': path});
      setState(() {
        _isRecording = true;
        _recordedPath = path;
      });
    } catch (e) {
      setState(() => _recorderAvailable = false);
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _channel.invokeMethod('stopRecording');
      setState(() => _isRecording = false);
      widget.onChanged(_recordedPath);
    } catch (e) {
      setState(() => _isRecording = false);
    }
  }

  Future<void> _playRecording() async {
    if (_recordedPath == null) return;
    try {
      if (_isPlaying) {
        await _player.stop();
        setState(() => _isPlaying = false);
      } else {
        await _player.play(DeviceFileSource(_recordedPath!));
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      setState(() => _isPlaying = false);
    }
  }

  void _deleteRecording() {
    setState(() => _recordedPath = null);
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    if (!_recorderAvailable) {
      return Text(
        'Voice recording not available on this device',
        style: AppTheme.caption(size: 12),
      );
    }
    if (_isRecording) return _buildRecordingState();
    if (_recordedPath != null && File(_recordedPath!).existsSync()) {
      return _buildPlaybackState();
    }
    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return OutlinedButton.icon(
      onPressed: _startRecording,
      icon: const Icon(Icons.mic, size: 18),
      label: const Text('Record Voice Clue'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 44),
        side: BorderSide(color: AppTheme.darkGold.withOpacity(0.4)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildRecordingState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
          const SizedBox(width: 10),
          Text('Recording...',
              style: AppTheme.body(size: 14, color: Colors.red)),
          const Spacer(),
          ElevatedButton(
            onPressed: _stopRecording,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 36),
            ),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackState() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.adventureGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.adventureGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _playRecording,
            icon: Icon(
              _isPlaying ? Icons.stop : Icons.play_arrow,
              color: AppTheme.adventureGreen,
            ),
          ),
          Text('Voice recorded',
              style: AppTheme.body(size: 13, color: AppTheme.adventureGreen)),
          const Spacer(),
          IconButton(
            onPressed: () {
              _deleteRecording();
              _startRecording();
            },
            icon: const Icon(Icons.refresh, size: 20),
          ),
          IconButton(
            onPressed: _deleteRecording,
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
          ),
        ],
      ),
    );
  }
}
