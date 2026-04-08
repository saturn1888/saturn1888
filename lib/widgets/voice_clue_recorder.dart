import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';

/// Widget for recording and playing back voice clues
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
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedPath;
  Duration _recordDuration = Duration.zero;

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
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/voice_clues/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await Directory('${dir.path}/voice_clues').create(recursive: true);

        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        setState(() => _isRecording = true);

        // Track duration
        _recordDuration = Duration.zero;
        Future.doWhile(() async {
          await Future.delayed(const Duration(seconds: 1));
          if (_isRecording && mounted) {
            setState(() => _recordDuration += const Duration(seconds: 1));
            return true;
          }
          return false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Microphone permission needed to record')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _recordedPath = path;
      });
      widget.onChanged(path);
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

  String get _durationText {
    final secs = _recordDuration.inSeconds;
    return '${(secs ~/ 60).toString().padLeft(1, '0')}:${(secs % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecording) {
      return _buildRecordingState();
    }
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
          // Pulsing red dot
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.3, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(value),
                ),
              );
            },
            onEnd: () {},
          ),
          const SizedBox(width: 10),
          Text('Recording... $_durationText',
              style: AppTheme.body(size: 14, color: Colors.red)),
          const Spacer(),
          ElevatedButton(
            onPressed: _stopRecording,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
        border:
            Border.all(color: AppTheme.adventureGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _playRecording,
            icon: Icon(
              _isPlaying ? Icons.stop : Icons.play_arrow,
              color: AppTheme.adventureGreen,
            ),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          Text(
            'Voice clue recorded',
            style: AppTheme.body(
                size: 13, color: AppTheme.adventureGreen),
          ),
          const Spacer(),
          // Re-record
          IconButton(
            onPressed: () {
              _deleteRecording();
              _startRecording();
            },
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Re-record',
          ),
          // Delete
          IconButton(
            onPressed: _deleteRecording,
            icon: Icon(Icons.delete_outline,
                size: 20, color: Colors.red[400]),
            tooltip: 'Remove voice clue',
          ),
        ],
      ),
    );
  }
}
