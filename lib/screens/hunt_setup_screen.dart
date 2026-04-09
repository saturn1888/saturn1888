import 'dart:math';
import 'package:flutter/material.dart';
import '../data/illustrations.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';
import '../widgets/adventure_widgets.dart';

class HuntSetupScreen extends StatefulWidget {
  const HuntSetupScreen({super.key});

  @override
  State<HuntSetupScreen> createState() => _HuntSetupScreenState();
}

class _HuntSetupScreenState extends State<HuntSetupScreen> {
  final _nameController = TextEditingController();
  HuntThemeType _selectedTheme = HuntThemeType.custom;
  int? _timerMinutes;
  bool _customTimer = false;
  final _customTimerController = TextEditingController();

  static const List<int?> _timerOptions = [null, 5, 10, 15, 20, 30];

  @override
  void dispose() {
    _nameController.dispose();
    _customTimerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(title: const Text('Hunt Setup'), actions: [const MuteButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdventureHeader(title: 'Hunt Name', emoji: '🏷️'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              maxLength: 40,
              decoration: const InputDecoration(
                hintText: 'e.g. Backyard Adventure',
                counterText: '',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            AdventureHeader(title: 'Choose a Theme', emoji: '🎨'),
            const SizedBox(height: 4),
            Text(
              'Each theme changes the look, language, and feel of your hunt',
              style: AppTheme.caption(size: 13),
            ),
            const SizedBox(height: 12),
            // Theme preview card
            _buildThemePreview(),
            const SizedBox(height: 12),
            // Theme selector - horizontal scrollable chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: HuntThemeData.all.length,
                itemBuilder: (context, index) {
                  final theme = HuntThemeData.all[index];
                  final isSelected = _selectedTheme == theme.type;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 4,
                      right: 4,
                    ),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(theme.emoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            theme.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.warmBrown,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.darkGold,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.darkGold
                              : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedTheme = theme.type),
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 24),
            AdventureHeader(title: 'Timer', emoji: '⏱️'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._timerOptions.map((minutes) {
                  final isSelected = !_customTimer && _timerMinutes == minutes;
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
                    onSelected: (_) => setState(() {
                      _timerMinutes = minutes;
                      _customTimer = false;
                    }),
                  );
                }),
                ChoiceChip(
                  label: Text(
                    'Custom',
                    style: TextStyle(
                      color: _customTimer ? Colors.white : AppTheme.warmBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: _customTimer,
                  selectedColor: AppTheme.darkGold,
                  backgroundColor: Colors.white,
                  onSelected: (_) => setState(() => _customTimer = true),
                ),
              ],
            ),
            if (_customTimer) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _customTimerController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Minutes',
                        isDense: true,
                      ),
                      onChanged: (v) {
                        final mins = int.tryParse(v);
                        if (mins != null && mins > 0) {
                          setState(() => _timerMinutes = mins);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('minutes', style: AppTheme.body(size: 14)),
                ],
              ),
            ],
            const SizedBox(height: 32),
            WoodButton(
              label: 'Next →',
              icon: Icons.arrow_forward,
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
                  '/treasure-items',
                  arguments: {
                    'name': name,
                    'theme': _selectedTheme,
                    'timer': _timerMinutes,
                    'treasureItems': <dynamic>[],
                    'clues': <dynamic>[],
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }

  Widget _buildThemePreview() {
    final theme = HuntThemeData.fromType(_selectedTheme);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Theme header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(theme.emoji, style: const TextStyle(fontSize: 36)),
                Image.asset(Illustrations.themeImage(theme.name),
                    width: 48,
                    height: 48,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme.name,
                        style: AppTheme.heading(
                            size: 18, color: theme.accentColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        theme.description,
                        style: AppTheme.caption(
                            size: 12,
                            color: theme.accentColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Mini clue card preview
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '"${theme.introMessage}"',
                  style: AppTheme.caption(
                      size: 11, color: theme.accentColor.withOpacity(0.8)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Decorative emojis row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: theme.decorativeEmojis
                      .take(5)
                      .map((e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child:
                                Text(e, style: const TextStyle(fontSize: 18)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Found it button preview
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: theme.accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                theme.foundItText,
                textAlign: TextAlign.center,
                style: AppTheme.heading(
                    size: 14, color: theme.backgroundColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints a theme card that looks like a beaten-up old map piece
class _WornMapCardPainter extends CustomPainter {
  final Color baseColor;
  final Color accentColor;
  final bool isSelected;
  final int seed;

  _WornMapCardPainter({
    required this.baseColor,
    required this.accentColor,
    required this.isSelected,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed * 5113);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Torn edge outline
    final outline = Path();
    const jag = 2.5;
    const step = 4.0;

    outline.moveTo(3, rng.nextDouble() * jag);
    for (double x = 3; x < size.width - 3; x += step) {
      outline.lineTo(x, rng.nextDouble() * jag);
    }
    for (double y = 0; y < size.height; y += step) {
      outline.lineTo(size.width - rng.nextDouble() * jag, y);
    }
    for (double x = size.width; x > 3; x -= step) {
      outline.lineTo(x, size.height - rng.nextDouble() * jag);
    }
    for (double y = size.height; y > 0; y -= step) {
      outline.lineTo(rng.nextDouble() * jag, y);
    }
    outline.close();

    // Drop shadow
    canvas.drawPath(
      outline.shift(const Offset(2, 3)),
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // Base fill
    canvas.save();
    canvas.clipPath(outline);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // Crumple/crease marks
    final creasePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (int i = 0; i < 5; i++) {
      final x1 = rng.nextDouble() * size.width;
      final y1 = rng.nextDouble() * size.height;
      final x2 = x1 + (rng.nextDouble() - 0.5) * size.width * 0.6;
      final y2 = y1 + (rng.nextDouble() - 0.5) * size.height * 0.4;
      creasePaint.color = Colors.white.withOpacity(0.04 + rng.nextDouble() * 0.06);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), creasePaint);
    }

    // Stain spots
    for (int i = 0; i < 4; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
          width: 8 + rng.nextDouble() * 18,
          height: 6 + rng.nextDouble() * 12,
        ),
        Paint()..color = Colors.black.withOpacity(0.03 + rng.nextDouble() * 0.04),
      );
    }

    // Grain dots
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 1.0,
        Paint()..color = Colors.white.withOpacity(0.02 + rng.nextDouble() * 0.03),
      );
    }

    // Burned edge vignette
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.2),
          ],
        ).createShader(rect),
    );

    canvas.restore();

    // Border
    canvas.drawPath(
      outline,
      Paint()
        ..color = isSelected
            ? accentColor.withOpacity(0.9)
            : Colors.black.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.0 : 1.0,
    );

    // Selection glow
    if (isSelected) {
      canvas.drawPath(
        outline,
        Paint()
          ..color = accentColor.withOpacity(0.15)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
