import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';

class ClueScreen extends StatefulWidget {
  const ClueScreen({super.key});

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {
  late Hunt _hunt;
  late HuntThemeData _theme;
  int _currentClueIndex = 0;
  bool _hintRevealed = false;
  bool _found = false;
  late ConfettiController _confettiController;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _timerExpired = false;
  late DateTime _startTime;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _startTime = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _hunt = ModalRoute.of(context)!.settings.arguments as Hunt;
      _theme = _hunt.theme;
      if (_hunt.timerMinutes != null) {
        _remainingSeconds = _hunt.timerMinutes! * 60;
        _startTimer();
      }
      _initialized = true;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        setState(() => _timerExpired = true);
        _showTimesUpDialog();
      }
    });
  }

  void _showTimesUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Time's Up! ⏰", style: AppTheme.heading(size: 24)),
        content: Text(
          'The timer has run out, but you can keep going!',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Going! 💪',
                style: AppTheme.body(size: 16, color: AppTheme.darkGold)),
          ),
        ],
      ),
    );
  }

  void _onFoundIt() {
    setState(() => _found = true);
    _confettiController.play();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_currentClueIndex < _hunt.clues.length - 1) {
        setState(() {
          _currentClueIndex++;
          _found = false;
          _hintRevealed = false;
        });
      } else {
        final totalSeconds = DateTime.now().difference(_startTime).inSeconds;
        _timer?.cancel();
        Navigator.pushReplacementNamed(
          context,
          '/victory',
          arguments: {
            'hunt': _hunt,
            'timeTaken': totalSeconds,
          },
        );
      }
    });
  }

  void _showHelpDialog() {
    final clue = _hunt.clues[_currentClueIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help 🆘', style: AppTheme.heading(size: 22)),
        content: Text(
          clue.wrongAnswerHint ?? 'No extra hint available for this clue. Look more carefully!',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it!',
                style: AppTheme.body(size: 16, color: AppTheme.darkGold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final clue = _hunt.clues[_currentClueIndex];
    final progress = (_currentClueIndex + 1) / _hunt.clues.length;

    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Quit Hunt?'),
                              content: const Text(
                                  'Are you sure you want to quit? Progress will be lost.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  child: const Text('Quit',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.close, color: _theme.accentColor),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Clue ${_currentClueIndex + 1} of ${_hunt.clues.length}',
                              style: AppTheme.heading(
                                size: 16,
                                color: _theme.accentColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor:
                                    _theme.accentColor.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation(
                                    _theme.accentColor),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_hunt.timerMinutes != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _remainingSeconds < 60 && !_timerExpired
                                ? Colors.red
                                : _theme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _timerExpired ? "Time's up!" : _timerText,
                            style: AppTheme.heading(
                              size: 16,
                              color: _remainingSeconds < 60
                                  ? Colors.white
                                  : _theme.accentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Clue card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      color: _theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _theme.emoji,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Text(
                                    clue.text,
                                    style: AppTheme.heading(
                                      size: 22,
                                      color: _theme.accentColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            if (clue.photoPath != null) ...[
                              const SizedBox(height: 16),
                              _buildPhotoHint(clue.photoPath!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _found ? null : _onFoundIt,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _found
                                ? Colors.green[300]
                                : _theme.accentColor,
                            foregroundColor: _theme.backgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _found ? 'Found! 🎉' : 'I Found It! ✅',
                            style: AppTheme.heading(
                              size: 22,
                              color: _theme.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _showHelpDialog,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                        ),
                        child: Text(
                          'Help 🆘',
                          style: AppTheme.body(
                            size: 16,
                            color: _theme.accentColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [
                  _theme.accentColor,
                  Colors.yellow,
                  Colors.pink,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                ],
                numberOfParticles: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoHint(String path) {
    final file = File(path);
    Widget imageWidget;

    if (file.existsSync()) {
      imageWidget = Image.file(
        file,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Container(
        height: 120,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 32, color: Colors.grey),
            Text('Image not found'),
          ],
        ),
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (!_hintRevealed)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: imageWidget,
                )
              else
                imageWidget,
            ],
          ),
        ),
        if (!_hintRevealed)
          TextButton(
            onPressed: () => setState(() => _hintRevealed = true),
            child: Text(
              'Reveal Hint 🔍',
              style: AppTheme.body(
                size: 14,
                color: _theme.accentColor,
              ),
            ),
          ),
      ],
    );
  }
}
