import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../models/trophy.dart';
import '../theme/app_theme.dart';

class VictoryScreen extends StatefulWidget {
  const VictoryScreen({super.key});

  @override
  State<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends State<VictoryScreen> {
  late ConfettiController _confettiController;
  late Hunt _hunt;
  late int _timeTaken;
  late HuntThemeData _theme;
  bool _saved = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _hunt = args['hunt'] as Hunt;
      _timeTaken = args['timeTaken'] as int;
      _theme = _hunt.theme;
      _confettiController.play();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String get _timeFormatted {
    final minutes = _timeTaken ~/ 60;
    final seconds = _timeTaken % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _saveTrophy() async {
    final trophy = Trophy(
      huntName: _hunt.name,
      themeType: _hunt.themeType,
      completedAt: DateTime.now(),
      timeTakenSeconds: _timeTaken,
      clueCount: _hunt.clues.length,
    );
    await Hive.box<Trophy>('trophies').add(trophy);
    setState(() => _saved = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trophy saved! 🏆'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _theme.emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Victory!',
                      style: AppTheme.heading(
                        size: 42,
                        color: _theme.accentColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hunt.name,
                      style: AppTheme.heading(
                        size: 22,
                        color: _theme.accentColor.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Time: $_timeFormatted',
                      style: AppTheme.body(
                        size: 20,
                        color: _theme.accentColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      color: _theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: _theme.accentColor.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          _hunt.victoryMessage,
                          style: AppTheme.heading(
                            size: 20,
                            color: _theme.accentColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saved ? null : _saveTrophy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _saved
                              ? Colors.grey
                              : _theme.accentColor,
                          foregroundColor: _theme.backgroundColor,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          _saved
                              ? 'Trophy Saved! ✅'
                              : 'Save to Trophy Cabinet 🏆',
                          style: AppTheme.heading(
                            size: 18,
                            color: _theme.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/play',
                                arguments: _hunt,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _theme.accentColor),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size(48, 48),
                            ),
                            child: Text(
                              'Play Again 🔄',
                              style: AppTheme.body(
                                size: 16,
                                color: _theme.accentColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _theme.accentColor),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size(48, 48),
                            ),
                            child: Text(
                              'Home 🏠',
                              style: AppTheme.body(
                                size: 16,
                                color: _theme.accentColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: [
                  _theme.accentColor,
                  Colors.yellow,
                  Colors.pink,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                ],
                numberOfParticles: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
