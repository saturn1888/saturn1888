import 'dart:math';
import 'package:flutter/material.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class HuntSetupScreen extends StatefulWidget {
  const HuntSetupScreen({super.key});

  @override
  State<HuntSetupScreen> createState() => _HuntSetupScreenState();
}

class _HuntSetupScreenState extends State<HuntSetupScreen> {
  final _nameController = TextEditingController();
  HuntThemeType _selectedTheme = HuntThemeType.pirate;
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
            Text('Hunt Name', style: AppTheme.heading(size: 20)),
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
            Text('Choose a Theme', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: HuntThemeData.all.length,
              itemBuilder: (context, index) {
                final theme = HuntThemeData.all[index];
                final isSelected = _selectedTheme == theme.type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTheme = theme.type),
                  child: CustomPaint(
                    painter: _WornMapCardPainter(
                      baseColor: theme.backgroundColor,
                      accentColor: theme.accentColor,
                      isSelected: isSelected,
                      seed: index,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                theme.emoji,
                                style: const TextStyle(fontSize: 34),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                theme.name,
                                style: AppTheme.heading(
                                  size: 13,
                                  color: theme.accentColor,
                                ),
                                textAlign: TextAlign.center,
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
            Text('Timer', style: AppTheme.heading(size: 20)),
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
    ));
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
