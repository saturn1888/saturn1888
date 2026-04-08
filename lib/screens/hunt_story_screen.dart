import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/hunt.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class HuntStoryScreen extends StatefulWidget {
  const HuntStoryScreen({super.key});

  @override
  State<HuntStoryScreen> createState() => _HuntStoryScreenState();
}

class _HuntStoryScreenState extends State<HuntStoryScreen> {
  late Hunt _hunt;
  late int _timeTaken;
  late HuntThemeData _theme;
  bool _initialized = false;
  final _storyKey = GlobalKey();
  bool _sharing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _hunt = args['hunt'] as Hunt;
      _timeTaken = args['timeTaken'] as int;
      _theme = _hunt.theme;
      _initialized = true;
    }
  }

  String get _timeFormatted {
    final minutes = _timeTaken ~/ 60;
    final seconds = _timeTaken % 60;
    return '${minutes}m ${seconds}s';
  }

  Future<void> _shareStory() async {
    setState(() => _sharing = true);
    try {
      // Capture the story widget as an image
      final boundary = _storyKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/ozhunt_story_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: '${_hunt.name} — completed in $_timeFormatted! 🎉 #OzHunt',
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hunt Story'),
          actions: const [MuteButton()],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: RepaintBoundary(
                  key: _storyKey,
                  child: _buildStoryCard(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _sharing ? null : _shareStory,
                  icon: _sharing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2))
                      : const Icon(Icons.share),
                  label: Text(
                    _sharing ? 'Preparing...' : 'Share Story',
                    style: AppTheme.heading(
                        size: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.adventureGreen,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _theme.cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Text(_theme.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(
                  _hunt.name,
                  style: AppTheme.heading(
                      size: 24, color: _theme.accentColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed in $_timeFormatted',
                  style: AppTheme.caption(
                      size: 15,
                      color: _theme.accentColor.withOpacity(0.7)),
                ),
              ],
            ),
          ),

          // Clue journey
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Adventure',
                  style: AppTheme.heading(
                      size: 18, color: _theme.accentColor),
                ),
                const SizedBox(height: 12),
                ...List.generate(_hunt.clues.length, (i) {
                  final clue = _hunt.clues[i];
                  final answer = clue.answer ?? 'Found!';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline dot and line
                        Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _theme.accentColor,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: AppTheme.heading(
                                      size: 13,
                                      color: _theme.backgroundColor),
                                ),
                              ),
                            ),
                            if (i < _hunt.clues.length - 1)
                              Container(
                                width: 2,
                                height: 24,
                                color: _theme.accentColor
                                    .withOpacity(0.3),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                answer,
                                style: AppTheme.heading(
                                    size: 15,
                                    color: _theme.accentColor),
                              ),
                              Text(
                                clue.text.split('\n').first,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.caption(
                                    size: 12,
                                    color: _theme.accentColor
                                        .withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Treasure items if any
          if (_hunt.treasureItems != null &&
              _hunt.treasureItems!.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Divider(
                      color:
                          _theme.accentColor.withOpacity(0.2)),
                  const SizedBox(height: 8),
                  Text(
                    'Treasures Collected',
                    style: AppTheme.heading(
                        size: 16, color: _theme.accentColor),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        _hunt.treasureItems!.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _theme.accentColor
                              .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${_theme.decorativeEmojis.isNotEmpty ? _theme.decorativeEmojis[0] : "🎁"} ${item.name}',
                          style: AppTheme.body(
                              size: 13,
                              color: _theme.accentColor),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Footer with decorative emojis
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _theme.decorativeEmojis
                      .take(5)
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4),
                            child: Text(e,
                                style: const TextStyle(fontSize: 22)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  'OzHunt Adventures',
                  style: AppTheme.caption(
                      size: 11,
                      color:
                          _theme.accentColor.withOpacity(0.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
