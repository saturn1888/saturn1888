import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trophy.dart';
import '../theme/app_theme.dart';
import '../widgets/music_controller.dart';
import '../widgets/mute_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    MusicController.instance.start();
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave OzHunt?', style: AppTheme.heading(size: 22)),
        content: Text(
          'Are you sure you want to exit the app?',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Stay', style: AppTheme.body(size: 16, color: AppTheme.darkGold)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8D5B8),
              Color(0xFFDCC8A8),
              Color(0xFFD4BC98),
              Color(0xFFCBB08A),
              Color(0xFFD4BC98),
            ],
            stops: [0.0, 0.25, 0.5, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _MapTexturePainter()),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.95,
                      colors: [
                        Colors.transparent,
                        Colors.brown.withOpacity(0.03),
                        Colors.brown.withOpacity(0.12),
                        Colors.brown.withOpacity(0.3),
                      ],
                      stops: const [0.5, 0.7, 0.85, 1.0],
                    ),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      // Logo
                      SizedBox(
                        width: 270,
                        height: 270,
                        child: CustomPaint(
                          foregroundPainter: _TornEdgeOverlayPainter(),
                          child: ClipPath(
                            clipper: _TornEdgeClipper(),
                            child: Image.asset(
                              'assets/images/ozhunt_logo.png',
                              width: 270,
                              height: 270,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 240,
                                  height: 240,
                                  color: AppTheme.warmBrown.withOpacity(0.2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('🗺️',
                                          style: TextStyle(fontSize: 80)),
                                      const SizedBox(height: 8),
                                      Text('OzHunt',
                                          style: AppTheme.heading(
                                              size: 32,
                                              color: AppTheme.warmBrown)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SignpostPlank(
                        label: 'Create a Hunt',
                        tilt: 0.02,
                        arrowDirection: 1,
                        seed: 1,
                        onTap: () => Navigator.pushNamed(context, '/setup'),
                      ),
                      const SizedBox(height: 10),
                      _SignpostPlank(
                        label: 'Play a Hunt',
                        tilt: -0.015,
                        arrowDirection: -1,
                        seed: 2,
                        onTap: () =>
                            Navigator.pushNamed(context, '/play-select'),
                      ),
                      const SizedBox(height: 10),
                      _SignpostPlank(
                        label: 'Join a Hunt',
                        tilt: 0.01,
                        arrowDirection: 1,
                        seed: 8,
                        onTap: () =>
                            Navigator.pushNamed(context, '/join-hunt'),
                      ),
                      const SizedBox(height: 10),
                      _SignpostPlank(
                        label: 'Manage Hunts',
                        tilt: -0.01,
                        arrowDirection: -1,
                        seed: 3,
                        onTap: () =>
                            Navigator.pushNamed(context, '/manage'),
                      ),
                      const SizedBox(height: 10),
                      // Exit plank — shorter, no arrow
                      SizedBox(
                        width: 180,
                        child: _SignpostPlank(
                          label: 'Exit',
                          tilt: 0.0,
                          arrowDirection: 0,
                          seed: 7,
                          onTap: () => _showExitConfirmation(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Player progression badge
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Trophy>('trophies').listenable(),
                        builder: (context, Box<Trophy> box, _) {
                          final count = box.length;
                          String tier;
                          String emoji;
                          int nextTarget;
                          if (count >= 25) {
                            tier = 'Master Explorer';
                            emoji = '🗺️';
                            nextTarget = count;
                          } else if (count >= 10) {
                            tier = 'Gold Hunter';
                            emoji = '🏆';
                            nextTarget = 25;
                          } else if (count >= 5) {
                            tier = 'Silver Hunter';
                            emoji = '⭐';
                            nextTarget = 10;
                          } else if (count >= 1) {
                            tier = 'Bronze Hunter';
                            emoji = '🥉';
                            nextTarget = 5;
                          } else {
                            tier = 'Rookie';
                            emoji = '🌱';
                            nextTarget = 1;
                          }
                          return GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/trophies'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppTheme.gold.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(emoji,
                                          style:
                                              const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8),
                                      Text(tier,
                                          style: AppTheme.heading(
                                              size: 15,
                                              color: AppTheme.warmBrown)),
                                    ],
                                  ),
                                  if (count < 25) ...[
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: 140,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: count / nextTarget,
                                          backgroundColor: Colors
                                              .grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation(
                                                  AppTheme.gold),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$count / $nextTarget hunts',
                                      style: AppTheme.caption(size: 10),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Mute button top-left — bigger, more visible
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () => MusicController.instance.toggleMute(),
                  child: ListenableBuilder(
                    listenable: MusicController.instance,
                    builder: (context, _) {
                      final muted = MusicController.instance.isMuted;
                      return CustomPaint(
                        painter: _WornBadgePainter(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Icon(
                            muted ? Icons.volume_off : Icons.volume_up,
                            color: const Color(0xFF4A2E14),
                            size: 26,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Trophy badge
              Positioned(
                top: 12,
                right: 12,
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Trophy>('trophies').listenable(),
                  builder: (context, Box<Trophy> box, _) {
                    return GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/trophies'),
                      child: CustomPaint(
                        painter: _WornBadgePainter(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🏆',
                                  style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 5),
                              Text(
                                '${box.length}',
                                style: AppTheme.heading(
                                    size: 18,
                                    color: const Color(0xFF4A2E14)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Text that looks hand-painted with a brush onto cloth
class _PaintedText extends StatelessWidget {
  final String text;
  const _PaintedText({required this.text});

  @override
  Widget build(BuildContext context) {
    final rng = Random(text.hashCode);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: text.split('').map((char) {
        final dy = (rng.nextDouble() - 0.5) * 1.5;
        final dx = (rng.nextDouble() - 0.5) * 0.4;
        final rotation = (rng.nextDouble() - 0.5) * 0.03;
        final sizeVar = 17.0 + (rng.nextDouble() - 0.5) * 2.0;
        // Vary opacity like paint thickness — some strokes heavier than others
        final opacity = 0.7 + rng.nextDouble() * 0.3;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.rotate(
            angle: rotation,
            child: Text(
              char,
              style: GoogleFonts.caveat(
                fontSize: sizeVar,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(80, 30, 10, opacity),
                height: 1.0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// A tilted wooden signpost plank with golden text
class _SignpostPlank extends StatelessWidget {
  final String label;
  final double tilt;
  final int arrowDirection; // 1 = right, -1 = left, 0 = no arrow
  final int seed;
  final VoidCallback onTap;

  const _SignpostPlank({
    required this.label,
    required this.tilt,
    required this.arrowDirection,
    required this.seed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: tilt,
        child: CustomPaint(
          painter: _SignpostPlankPainter(
            seed: seed,
            arrowDirection: arrowDirection,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: arrowDirection == -1 ? 32 : 20,
              right: arrowDirection == 1 ? 32 : 20,
            ),
            alignment: Alignment.center,
            child: _GoldenCarvedText(label: label, seed: seed),
          ),
        ),
      ),
    );
  }
}

/// Golden text with slight roughness — like painted/burned onto wood
class _GoldenCarvedText extends StatelessWidget {
  final String label;
  final int seed;
  final double fontSize;
  const _GoldenCarvedText({
    required this.label,
    required this.seed,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final rng = Random(seed * 31 + label.hashCode);
    final upper = label.toUpperCase();
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dark shadow behind text
        Transform.translate(
          offset: const Offset(1.0, 1.5),
          child: Text(
            upper,
            textAlign: TextAlign.center,
            style: GoogleFonts.specialElite(
              fontSize: fontSize,
              color: Colors.black.withOpacity(0.5),
              letterSpacing: 1.2,
            ),
          ),
        ),
        // Individual letters with slight wobble
        Wrap(
          alignment: WrapAlignment.center,
          children: upper.split('').map((char) {
            final dy = (rng.nextDouble() - 0.5) * 2.0;
            final dx = (rng.nextDouble() - 0.5) * 0.8;
            final rotation = (rng.nextDouble() - 0.5) * 0.04;
            final sizeVar = fontSize + (rng.nextDouble() - 0.5) * 2.5;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.rotate(
                angle: rotation,
                child: Text(
                  char,
                  style: GoogleFonts.specialElite(
                    fontSize: sizeVar,
                    color: const Color(0xFFFFD480),
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFF8C00).withOpacity(0.4),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Paints a wooden signpost plank with arrow-shaped end, grain, and nail
class _SignpostPlankPainter extends CustomPainter {
  final int seed;
  final int arrowDirection;
  _SignpostPlankPainter({required this.seed, required this.arrowDirection});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed * 7919);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // — Build plank shape with pointed arrow end —
    final plank = Path();
    const jag = 1.5;
    const step = 5.0;
    final arrowDepth = 18.0;
    final midY = size.height / 2;

    if (arrowDirection == 0) {
      // Plain rectangular plank — no arrow
      plank.moveTo(4, rng.nextDouble() * jag);
      for (double x = 4; x < size.width - 4; x += step) {
        plank.lineTo(x, rng.nextDouble() * jag);
      }
      plank.lineTo(size.width, rng.nextDouble() * jag * 2);
      plank.lineTo(size.width, size.height - rng.nextDouble() * jag * 2);
      for (double x = size.width - 4; x > 4; x -= step) {
        plank.lineTo(x, size.height - rng.nextDouble() * jag);
      }
      plank.lineTo(0, size.height - rng.nextDouble() * jag * 2);
      plank.lineTo(0, rng.nextDouble() * jag * 2);
    } else if (arrowDirection == 1) {
      // Point on the right side
      plank.moveTo(4, rng.nextDouble() * jag);
      for (double x = 4; x < size.width - arrowDepth; x += step) {
        plank.lineTo(x, rng.nextDouble() * jag);
      }
      plank.lineTo(size.width - arrowDepth, 0);
      plank.lineTo(size.width, midY);
      plank.lineTo(size.width - arrowDepth, size.height);
      for (double x = size.width - arrowDepth; x > 4; x -= step) {
        plank.lineTo(x, size.height - rng.nextDouble() * jag);
      }
      plank.lineTo(0, size.height - rng.nextDouble() * jag * 2);
      plank.lineTo(0, rng.nextDouble() * jag * 2);
    } else {
      // Point on the left side
      plank.moveTo(arrowDepth, rng.nextDouble() * jag);
      for (double x = arrowDepth; x < size.width - 4; x += step) {
        plank.lineTo(x, rng.nextDouble() * jag);
      }
      plank.lineTo(size.width, rng.nextDouble() * jag * 2);
      plank.lineTo(size.width, size.height - rng.nextDouble() * jag * 2);
      for (double x = size.width - 4; x > arrowDepth; x -= step) {
        plank.lineTo(x, size.height - rng.nextDouble() * jag);
      }
      plank.lineTo(arrowDepth, size.height);
      plank.lineTo(0, midY);
      plank.lineTo(arrowDepth, 0);
    }
    plank.close();

    // — Drop shadow —
    canvas.drawPath(
      plank.shift(const Offset(3, 4)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.3),
    );

    // — Wood fill —
    canvas.save();
    canvas.clipPath(plank);

    // Warm bright wood base
    final woodBase = Color.lerp(
      const Color(0xFFA87840),
      const Color(0xFF9A6B35),
      rng.nextDouble(),
    )!;
    canvas.drawRect(rect, Paint()..color = woodBase);

    // — Horizontal wood grain —
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 20; i++) {
      final y = rng.nextDouble() * size.height;
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 10) {
        path.lineTo(x, y + (rng.nextDouble() - 0.5) * 2.5);
      }
      final isDark = rng.nextBool();
      grainPaint
        ..color = isDark
            ? const Color(0xFF6B4A2E).withOpacity(0.10 + rng.nextDouble() * 0.10)
            : const Color(0xFFC09560).withOpacity(0.08 + rng.nextDouble() * 0.10)
        ..strokeWidth = 0.5 + rng.nextDouble() * 1.2;
      canvas.drawPath(path, grainPaint);
    }

    // — Knot (one per plank) —
    final kx = 30 + rng.nextDouble() * (size.width - 60);
    final ky = 6 + rng.nextDouble() * (size.height - 12);
    final kr = 3.0 + rng.nextDouble() * 4;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(kx, ky), width: kr * 2, height: kr * 1.4),
      Paint()..color = const Color(0xFF5C3A1E).withOpacity(0.2),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(kx, ky), width: kr * 3.5, height: kr * 2.5),
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // — Top bevel highlight —
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.4),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.transparent,
          ],
        ).createShader(rect),
    );

    // — Bottom shadow for thickness —
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.75, size.width, size.height * 0.25),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.15),
          ],
        ).createShader(rect),
    );

    // — Scratches —
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        Paint()
          ..color = Colors.white.withOpacity(0.04 + rng.nextDouble() * 0.05)
          ..strokeWidth = 0.4,
      );
    }

    // — Nail hole (near the non-arrow end) —
    final nailX = arrowDirection == 0
        ? size.width / 2
        : arrowDirection == 1 ? 14.0 : size.width - 14.0;
    final nailY = midY;
    canvas.drawCircle(
      Offset(nailX + 0.5, nailY + 1),
      4.5,
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.35),
    );
    canvas.drawCircle(
      Offset(nailX, nailY),
      4,
      Paint()..color = const Color(0xFF3A3535),
    );
    canvas.drawCircle(
      Offset(nailX - 1, nailY - 1),
      1.5,
      Paint()..color = Colors.white.withOpacity(0.18),
    );

    // — Edge vignette —
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [
            Colors.transparent,
            const Color(0xFF3E2010).withOpacity(0.10),
          ],
        ).createShader(rect),
    );

    canvas.restore();

    // — Outline —
    canvas.drawPath(
      plank,
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Weathered badge for trophy counter
class _WornBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(55);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      rect.shift(const Offset(1, 2)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.2),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFD9C4A5));
    canvas.save();
    canvas.clipRRect(rect);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        3 + rng.nextDouble() * 5,
        Paint()..color = const Color(0xFF8B6914).withOpacity(0.06),
      );
    }
    canvas.restore();
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFF5C3317).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints a wooden sign hanging from two worn ropes connected to the logo above
class _HangingSignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(88);
    final w = size.width;
    final h = size.height;

    // Rope attachment points — top at logo corners, bottom at plank edges
    // Logo is 270px wide centred in 300px, so corners at ~15 and ~285
    final ropeTopLeftX = 15.0;
    final ropeTopRightX = w - 15.0;
    const ropeTopY = 0.0;
    final plankTop = h * 0.22;
    final plankLeftRopeX = 24.0;
    final plankRightRopeX = w - 24.0;

    // — Draw ropes (behind the plank) —
    final ropePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Left rope — 5 strands twisted for thick worn rope
    for (int strand = 0; strand < 5; strand++) {
      final strandOffset = (strand - 2) * 1.3;
      // Twist effect — each strand wobbles slightly
      final twistPhase = strand * 0.8;
      final ropePath = Path()..moveTo(ropeTopLeftX + strandOffset, ropeTopY);
      final steps = 12;
      for (int i = 1; i <= steps; i++) {
        final t = i / steps;
        // Lerp from top to bottom with sag
        final x = ropeTopLeftX + (plankLeftRopeX - ropeTopLeftX) * t +
            sin(t * pi + twistPhase) * 3 + strandOffset;
        final y = ropeTopY + (plankTop + 2 - ropeTopY) * t +
            sin(t * pi) * 6; // sag
        ropePath.lineTo(x, y);
      }
      ropePaint
        ..color = Color.lerp(
          const Color(0xFF9B8060),
          const Color(0xFF6B5030),
          rng.nextDouble(),
        )!.withOpacity(0.5 + rng.nextDouble() * 0.4)
        ..strokeWidth = 2.5 - (strand - 2).abs() * 0.4;
      canvas.drawPath(ropePath, ropePaint);
    }

    // Right rope — 5 strands
    for (int strand = 0; strand < 5; strand++) {
      final strandOffset = (strand - 2) * 1.3;
      final twistPhase = strand * 0.8;
      final ropePath = Path()..moveTo(ropeTopRightX + strandOffset, ropeTopY);
      final steps = 12;
      for (int i = 1; i <= steps; i++) {
        final t = i / steps;
        final x = ropeTopRightX + (plankRightRopeX - ropeTopRightX) * t +
            sin(t * pi + twistPhase) * 3 + strandOffset;
        final y = ropeTopY + (plankTop + 2 - ropeTopY) * t +
            sin(t * pi) * 6;
        ropePath.lineTo(x, y);
      }
      ropePaint
        ..color = Color.lerp(
          const Color(0xFF9B8060),
          const Color(0xFF6B5030),
          rng.nextDouble(),
        )!.withOpacity(0.5 + rng.nextDouble() * 0.4)
        ..strokeWidth = 2.5 - (strand - 2).abs() * 0.4;
      canvas.drawPath(ropePath, ropePaint);
    }

    // Frayed rope fibers at attachment points
    final fiberPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
    for (final attachX in [ropeTopLeftX, ropeTopRightX]) {
      for (int i = 0; i < 8; i++) {
        fiberPaint.color = const Color(0xFF9B8060).withOpacity(0.2 + rng.nextDouble() * 0.25);
        final fx = attachX + (rng.nextDouble() - 0.5) * 10;
        canvas.drawLine(
          Offset(fx, ropeTopY),
          Offset(fx + (rng.nextDouble() - 0.5) * 4, ropeTopY + 3 + rng.nextDouble() * 5),
          fiberPaint,
        );
      }
    }

    // — Draw wooden plank sign —
    final plankRect = Rect.fromLTWH(8, plankTop, w - 16, h - plankTop - 4);
    final plank = Path();
    const jag = 1.5;
    const step = 5.0;

    // Rough edges
    plank.moveTo(plankRect.left + 3, plankRect.top + rng.nextDouble() * jag);
    for (double x = plankRect.left + 3; x < plankRect.right - 3; x += step) {
      plank.lineTo(x, plankRect.top + rng.nextDouble() * jag);
    }
    for (double y = plankRect.top; y < plankRect.bottom; y += step) {
      plank.lineTo(plankRect.right - rng.nextDouble() * jag, y);
    }
    for (double x = plankRect.right; x > plankRect.left + 3; x -= step) {
      plank.lineTo(x, plankRect.bottom - rng.nextDouble() * jag);
    }
    for (double y = plankRect.bottom; y > plankRect.top; y -= step) {
      plank.lineTo(plankRect.left + rng.nextDouble() * jag, y);
    }
    plank.close();

    // Shadow
    canvas.drawPath(
      plank.shift(const Offset(2, 3)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.25),
    );

    // Wood fill
    canvas.save();
    canvas.clipPath(plank);
    canvas.drawRect(plankRect, Paint()..color = const Color(0xFFA07040));

    // Wood grain
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 15; i++) {
      final y = plankRect.top + rng.nextDouble() * plankRect.height;
      final path = Path()..moveTo(plankRect.left, y);
      for (double x = plankRect.left; x < plankRect.right; x += 8) {
        path.lineTo(x, y + (rng.nextDouble() - 0.5) * 2);
      }
      grainPaint
        ..color = rng.nextBool()
            ? const Color(0xFF5C3A1E).withOpacity(0.08 + rng.nextDouble() * 0.08)
            : const Color(0xFFC09560).withOpacity(0.06 + rng.nextDouble() * 0.08)
        ..strokeWidth = 0.4 + rng.nextDouble() * 1.0;
      canvas.drawPath(path, grainPaint);
    }

    // Bevel highlight top
    canvas.drawRect(
      Rect.fromLTWH(plankRect.left, plankRect.top, plankRect.width, plankRect.height * 0.35),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.12), Colors.transparent],
        ).createShader(plankRect),
    );
    // Shadow bottom
    canvas.drawRect(
      Rect.fromLTWH(plankRect.left, plankRect.bottom - plankRect.height * 0.25,
          plankRect.width, plankRect.height * 0.25),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.12)],
        ).createShader(plankRect),
    );

    canvas.restore();

    // Plank outline
    canvas.drawPath(
      plank,
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Rope holes on the plank (where rope threads through)
    for (final hx in [plankLeftRopeX, plankRightRopeX]) {
      canvas.drawCircle(
        Offset(hx, plankTop + 5),
        3,
        Paint()..color = const Color(0xFF2A1508).withOpacity(0.4),
      );
      canvas.drawCircle(
        Offset(hx - 0.5, plankTop + 4.5),
        1.2,
        Paint()..color = Colors.white.withOpacity(0.1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// Background texture and logo edge painters
// ============================================================

class _MapTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);

    // Fold creases
    final creasePaint = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.10)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final creaseShadow = Paint()
      ..color = const Color(0xFF5C3317).withOpacity(0.05)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (final frac in [0.33, 0.5, 0.67]) {
      final y = size.height * frac;
      final p = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 6) {
        p.lineTo(x, y + rng.nextDouble() * 6 - 3);
      }
      canvas.drawPath(p.shift(const Offset(0, 1.5)), creaseShadow);
      canvas.drawPath(p, creasePaint);
    }
    for (final frac in [0.35, 0.5, 0.65]) {
      final x = size.width * frac;
      final p = Path()..moveTo(x, 0);
      for (double y = 0; y < size.height; y += 6) {
        p.lineTo(x + rng.nextDouble() * 5 - 2.5, y);
      }
      canvas.drawPath(p.shift(const Offset(1.5, 0)), creaseShadow);
      canvas.drawPath(p, creasePaint);
    }

    // Diagonal crumples
    for (int i = 0; i < 10; i++) {
      final x1 = rng.nextDouble() * size.width;
      final y1 = rng.nextDouble() * size.height;
      final len = 40 + rng.nextDouble() * size.width * 0.4;
      final angle = rng.nextDouble() * pi;
      final path = Path()..moveTo(x1, y1);
      path.quadraticBezierTo(
        x1 + cos(angle) * len * 0.5 + (rng.nextDouble() - 0.5) * 30,
        y1 + sin(angle) * len * 0.5 + (rng.nextDouble() - 0.5) * 30,
        x1 + cos(angle) * len,
        y1 + sin(angle) * len,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF8B7355).withOpacity(0.03 + rng.nextDouble() * 0.04)
          ..strokeWidth = 0.6 + rng.nextDouble() * 1.0
          ..style = PaintingStyle.stroke,
      );
    }

    // Tea stains
    for (int i = 0; i < 15; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
          width: (10 + rng.nextDouble() * 40) * (0.8 + rng.nextDouble() * 0.6),
          height: (10 + rng.nextDouble() * 40) * (0.5 + rng.nextDouble() * 0.5),
        ),
        Paint()
          ..color = Color.lerp(
            const Color(0xFF8B6914),
            const Color(0xFF6B4226),
            rng.nextDouble(),
          )!.withOpacity(0.02 + rng.nextDouble() * 0.03),
      );
    }

    // Paper grain
    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 250; i++) {
      grainPaint.color = const Color(0xFF8B7355).withOpacity(0.015 + rng.nextDouble() * 0.025);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 1.5,
        grainPaint,
      );
    }

    // Compass rose
    final cp = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.07)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    final cc = Offset(size.width * 0.12, size.height * 0.9);
    const cr = 28.0;
    canvas.drawCircle(cc, cr, cp);
    canvas.drawCircle(cc, cr * 0.55, cp);
    for (final a in [0.0, pi / 2, pi, 3 * pi / 2]) {
      canvas.drawLine(
        cc + Offset(cos(a) * cr * 0.2, sin(a) * cr * 0.2),
        cc + Offset(cos(a) * (cr + 4), sin(a) * (cr + 4)),
        cp,
      );
    }
    for (final a in [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4]) {
      canvas.drawLine(
        cc + Offset(cos(a) * cr * 0.3, sin(a) * cr * 0.3),
        cc + Offset(cos(a) * cr * 0.8, sin(a) * cr * 0.8),
        cp..strokeWidth = 0.4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TornEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final rng = Random(77);
    final path = Path();
    const inset = 6.0;
    const jag = 5.0;
    const step = 4.0;
    path.moveTo(inset + rng.nextDouble() * jag, inset + rng.nextDouble() * jag);
    for (double x = inset; x < size.width - inset; x += step) {
      path.lineTo(x, inset + rng.nextDouble() * jag * 2);
    }
    for (double y = inset; y < size.height - inset; y += step) {
      path.lineTo(size.width - inset - rng.nextDouble() * jag * 2, y);
    }
    for (double x = size.width - inset; x > inset; x -= step) {
      path.lineTo(x, size.height - inset - rng.nextDouble() * jag * 2);
    }
    for (double y = size.height - inset; y > inset; y -= step) {
      path.lineTo(inset + rng.nextDouble() * jag * 2, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TornEdgeOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(99);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.75,
          colors: [
            Colors.transparent,
            Colors.transparent,
            const Color(0xFF3E2010).withOpacity(0.25),
            const Color(0xFF2A1508).withOpacity(0.6),
          ],
          stops: const [0.0, 0.55, 0.8, 1.0],
        ).createShader(rect),
    );
    final scorchPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 15; i++) {
      final edge = rng.nextInt(4);
      double x, y;
      switch (edge) {
        case 0: x = rng.nextDouble() * size.width; y = rng.nextDouble() * 10; break;
        case 1: x = rng.nextDouble() * size.width; y = size.height - rng.nextDouble() * 10; break;
        case 2: x = rng.nextDouble() * 10; y = rng.nextDouble() * size.height; break;
        default: x = size.width - rng.nextDouble() * 10; y = rng.nextDouble() * size.height;
      }
      scorchPaint.color = const Color(0xFF1A0E05).withOpacity(0.08 + rng.nextDouble() * 0.1);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: 6 + rng.nextDouble() * 12,
          height: 3 + rng.nextDouble() * 8,
        ),
        scorchPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
