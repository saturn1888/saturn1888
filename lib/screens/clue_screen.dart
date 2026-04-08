import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';

class ClueScreen extends StatefulWidget {
  const ClueScreen({super.key});

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen>
    with TickerProviderStateMixin {
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

  // Intro + Countdown state
  bool _showIntro = true;
  bool _showCountdown = false;
  int _countdownValue = 3;
  Timer? _countdownTimer;
  late AnimationController _countdownAnimController;
  late Animation<double> _countdownScale;

  // Help button pulse
  Timer? _helpPulseTimer;
  late AnimationController _helpPulseController;
  bool _showHelpPulse = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _startTime = DateTime.now();

    _countdownAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _countdownScale = Tween<double>(begin: 1.5, end: 0.8).animate(
      CurvedAnimation(
        parent: _countdownAnimController,
        curve: Curves.easeOut,
      ),
    );

    _helpPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _hunt = ModalRoute.of(context)!.settings.arguments as Hunt;
      _theme = _hunt.theme;
      _initialized = true;
    }
  }

  void _startCountdown() {
    _countdownAnimController.forward();
    HapticFeedback.mediumImpact();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdownValue > 1) {
        setState(() => _countdownValue--);
        _countdownAnimController.reset();
        _countdownAnimController.forward();
        HapticFeedback.mediumImpact();
      } else {
        timer.cancel();
        setState(() => _showCountdown = false);
        HapticFeedback.heavyImpact();
        _resetHelpPulse();
        _startTime = DateTime.now();
        if (_hunt.timerMinutes != null) {
          _remainingSeconds = _hunt.timerMinutes! * 60;
          _startTimer();
        }
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        if (_remainingSeconds == 59) {
          HapticFeedback.heavyImpact();
        }
      } else {
        timer.cancel();
        setState(() => _timerExpired = true);
        HapticFeedback.heavyImpact();
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

  void _resetHelpPulse() {
    _helpPulseTimer?.cancel();
    setState(() => _showHelpPulse = false);
    _helpPulseTimer = Timer(const Duration(seconds: 30), () {
      if (mounted && !_found) {
        setState(() => _showHelpPulse = true);
        HapticFeedback.lightImpact();
      }
    });
  }

  void _onFoundIt() {
    HapticFeedback.heavyImpact();
    _helpPulseTimer?.cancel();
    setState(() {
      _found = true;
      _showHelpPulse = false;
    });
    _confettiController.play();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_currentClueIndex < _hunt.clues.length - 1) {
        setState(() {
          _currentClueIndex++;
          _found = false;
          _hintRevealed = false;
        });
        _resetHelpPulse();
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

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How to Play', style: AppTheme.heading(size: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ruleRow('1', 'Read the riddle clue'),
            const SizedBox(height: 8),
            _ruleRow('2', 'Search the area and find the answer'),
            const SizedBox(height: 8),
            _ruleRow('3', 'Tap "I Found It!" when you find it'),
            const SizedBox(height: 8),
            _ruleRow('4', 'Use hints if you get stuck'),
            if (_hunt.treasureItems != null &&
                _hunt.treasureItems!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _ruleRow('5', 'Collect the treasure at each spot!'),
            ],
          ],
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

  Widget _ruleRow(String num, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: _theme.accentColor,
          child: Text(num,
              style: AppTheme.heading(size: 12, color: _theme.backgroundColor)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTheme.body(size: 15))),
      ],
    );
  }

  void _showHelpDialog() {
    final clue = _hunt.clues[_currentClueIndex];
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help 🆘', style: AppTheme.heading(size: 22)),
        content: Text(
          clue.wrongAnswerHint ??
              'No extra hint available for this clue. Look more carefully!',
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
    _countdownTimer?.cancel();
    _helpPulseTimer?.cancel();
    _countdownAnimController.dispose();
    _helpPulseController.dispose();
    super.dispose();
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _dismissIntro() {
    setState(() {
      _showIntro = false;
      _showCountdown = true;
    });
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return _buildIntroScreen();
    }
    if (_showCountdown) {
      return _buildCountdownScreen();
    }

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
                        onPressed: _showRulesDialog,
                        icon: Icon(Icons.help_outline,
                            color: _theme.accentColor, size: 22),
                        tooltip: 'How to Play',
                      ),
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
                                valueColor:
                                    AlwaysStoppedAnimation(_theme.accentColor),
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
                            backgroundColor:
                                _found ? Colors.green[300] : _theme.accentColor,
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
                      FadeTransition(
                        opacity: _showHelpPulse
                            ? Tween<double>(begin: 0.4, end: 1.0)
                                .animate(_helpPulseController)
                            : const AlwaysStoppedAnimation(1.0),
                        child: TextButton(
                          onPressed: () {
                            _helpPulseTimer?.cancel();
                            setState(() => _showHelpPulse = false);
                            _showHelpDialog();
                          },
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            backgroundColor: _showHelpPulse
                                ? _theme.accentColor.withOpacity(0.15)
                                : null,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _showHelpPulse ? 'Need a hint? 🆘' : 'Help 🆘',
                            style: AppTheme.body(
                              size: 16,
                              color: _theme.accentColor.withOpacity(0.8),
                            ),
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

  Widget _buildIntroScreen() {
    final hasPrize = _hunt.prizeDescription != null &&
        _hunt.prizeDescription!.isNotEmpty;
    final hasPrizePhoto = _hunt.prizePhotoPath != null;

    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _theme.emoji,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 12),
                Text(
                  _hunt.name,
                  style: AppTheme.heading(size: 28, color: _theme.accentColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // How to play card
                Card(
                  color: _theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'How to Play',
                          style: AppTheme.heading(
                            size: 22,
                            color: _theme.accentColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _introStep('1', 'Read the riddle clue',
                            'Each clue is a riddle hinting at a location or object'),
                        const SizedBox(height: 12),
                        _introStep('2', 'Search and find it!',
                            'Look around — the answer is nearby'),
                        const SizedBox(height: 12),
                        _introStep('3', 'Tap "I Found It!"',
                            'Then pass the phone for the next clue'),
                        if (hasPrize || hasPrizePhoto) ...[
                          const SizedBox(height: 12),
                          _introStep('4', 'Collect the treasure!',
                              'There\'s something hidden at each spot'),
                        ],
                      ],
                    ),
                  ),
                ),

                // Prize section
                if (hasPrize || hasPrizePhoto) ...[
                  const SizedBox(height: 20),
                  Card(
                    color: _theme.accentColor.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _theme.accentColor.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'You\'re looking for...',
                            style: AppTheme.body(
                              size: 14,
                              color: _theme.accentColor.withOpacity(0.7),
                            ),
                          ),
                          if (hasPrize) ...[
                            const SizedBox(height: 8),
                            Text(
                              _hunt.prizeDescription!,
                              style: AppTheme.heading(
                                size: 20,
                                color: _theme.accentColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          if (hasPrizePhoto) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _buildPrizeImage(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                // Timer info
                if (_hunt.timerMinutes != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: _theme.accentColor, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${_hunt.timerMinutes} minute timer',
                        style: AppTheme.body(
                          size: 15,
                          color: _theme.accentColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _dismissIntro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _theme.accentColor,
                      foregroundColor: _theme.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Let\'s Go!',
                      style: AppTheme.heading(
                        size: 24,
                        color: _theme.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _introStep(String number, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: _theme.accentColor,
          child: Text(
            number,
            style: AppTheme.heading(size: 14, color: _theme.backgroundColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.heading(size: 16, color: _theme.accentColor),
              ),
              Text(
                subtitle,
                style: AppTheme.body(
                  size: 13,
                  color: _theme.accentColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrizeImage() {
    final file = File(_hunt.prizePhotoPath!);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
      );
    }
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
    );
  }

  Widget _buildCountdownScreen() {
    final label = _countdownValue > 0 ? '$_countdownValue' : 'GO!';
    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _theme.emoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              _hunt.name,
              style: AppTheme.heading(size: 24, color: _theme.accentColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            AnimatedBuilder(
              animation: _countdownScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _countdownScale.value,
                  child: Text(
                    label,
                    style: AppTheme.heading(
                      size: 96,
                      color: _theme.accentColor,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Get ready!',
              style: AppTheme.body(
                size: 18,
                color: _theme.accentColor.withOpacity(0.7),
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

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
