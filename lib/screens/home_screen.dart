import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trophy.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD9C4A5),
              Color(0xFFCBB48E),
              Color(0xFFB8A070),
              Color(0xFFAA8E5A),
              Color(0xFFBFA878),
            ],
            stops: [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _MapTexturePainter()),
              ),
              // Heavy burned edge vignette
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.85,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF3E2010).withOpacity(0.05),
                        const Color(0xFF3E2010).withOpacity(0.18),
                        const Color(0xFF2A1508).withOpacity(0.45),
                        const Color(0xFF1A0A02).withOpacity(0.75),
                      ],
                      stops: const [0.3, 0.5, 0.7, 0.85, 1.0],
                    ),
                  ),
                ),
              ),
              // Corner burns
              ..._buildCornerBurns(),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // Logo with torn edges
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
                                  width: 270,
                                  height: 270,
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
                      const SizedBox(height: 6),
                      Text(
                        'Family Scavenger Hunts!',
                        style: AppTheme.heading(
                          size: 17,
                          color: const Color(0xFF4A2E14),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _WoodPlankButton(
                        label: 'Create a Hunt',
                        seed: 1,
                        onTap: () => Navigator.pushNamed(context, '/setup'),
                      ),
                      const SizedBox(height: 14),
                      _WoodPlankButton(
                        label: 'Play a Hunt',
                        seed: 2,
                        onTap: () =>
                            Navigator.pushNamed(context, '/play-select'),
                      ),
                      const SizedBox(height: 14),
                      _WoodPlankButton(
                        label: 'Manage Hunts',
                        seed: 3,
                        onTap: () =>
                            Navigator.pushNamed(context, '/manage'),
                      ),
                      const SizedBox(height: 24),
                    ],
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

  static List<Widget> _buildCornerBurns() {
    return [
      // Top-left
      Positioned(
        top: 0, left: 0,
        child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.0,
              colors: [
                const Color(0xFF1A0A02).withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0, right: 0,
        child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.0,
              colors: [
                const Color(0xFF1A0A02).withOpacity(0.45),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0, left: 0,
        child: Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomLeft,
              radius: 1.0,
              colors: [
                const Color(0xFF1A0A02).withOpacity(0.55),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0, right: 0,
        child: Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomRight,
              radius: 1.0,
              colors: [
                const Color(0xFF1A0A02).withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }
}

/// A button that looks like a rough-cut wooden plank with carved text
class _WoodPlankButton extends StatelessWidget {
  final String label;
  final int seed;
  final VoidCallback onTap;

  const _WoodPlankButton({
    required this.label,
    required this.seed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _WoodPlankPainter(seed: seed),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          alignment: Alignment.center,
          child: _CarvedText(label: label),
        ),
      ),
    );
  }
}

/// Text that looks knife-carved into wood
class _CarvedText extends StatelessWidget {
  final String label;
  const _CarvedText({required this.label});

  TextStyle _carveStyle(double size, Color color) {
    return GoogleFonts.specialElite(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final rng = Random(label.hashCode);
    final upper = label.toUpperCase();
    return Stack(
      alignment: Alignment.center,
      children: [
        // Deep gouge shadow
        Transform.translate(
          offset: const Offset(1.0, 1.8),
          child: Text(upper, style: _carveStyle(22, Colors.black.withOpacity(0.4))),
        ),
        // Light catching the chisel edge
        Transform.translate(
          offset: const Offset(-0.6, -0.6),
          child: Text(upper, style: _carveStyle(22, Colors.white.withOpacity(0.25))),
        ),
        // Each letter individually carved — wobble, tilt, varied depth
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: upper.split('').map((char) {
            final dy = (rng.nextDouble() - 0.5) * 2.5;
            final dx = (rng.nextDouble() - 0.5) * 1.0;
            final rotation = (rng.nextDouble() - 0.5) * 0.06;
            final sizeVar = 21.0 + (rng.nextDouble() - 0.5) * 3.0;
            final depthVar = 0.7 + rng.nextDouble() * 0.3;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.rotate(
                angle: rotation,
                child: Text(
                  char,
                  style: _carveStyle(
                    sizeVar,
                    Color.fromRGBO(14, 7, 2, depthVar),
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

/// Paints a rough-cut wooden plank with grain, knots, nails, and weathering
class _WoodPlankPainter extends CustomPainter {
  final int seed;
  _WoodPlankPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed * 7919);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // — Rough plank outline (not perfectly rectangular) —
    final plank = Path();
    const jag = 2.0;
    const step = 5.0;
    const cornerR = 4.0;

    // Top edge
    plank.moveTo(cornerR, rng.nextDouble() * jag);
    for (double x = cornerR; x < size.width - cornerR; x += step) {
      plank.lineTo(x, rng.nextDouble() * jag);
    }
    // Right edge
    for (double y = 0; y < size.height; y += step) {
      plank.lineTo(size.width - rng.nextDouble() * jag, y);
    }
    // Bottom edge
    for (double x = size.width; x > cornerR; x -= step) {
      plank.lineTo(x, size.height - rng.nextDouble() * jag);
    }
    // Left edge
    for (double y = size.height; y > 0; y -= step) {
      plank.lineTo(rng.nextDouble() * jag, y);
    }
    plank.close();

    // — Drop shadow —
    canvas.drawPath(
      plank.shift(const Offset(3, 4)),
      Paint()..color = const Color(0xFF0A0502).withOpacity(0.35),
    );

    // — Wood base colour —
    canvas.save();
    canvas.clipPath(plank);

    // Base warm wood
    final woodBase = Color.lerp(
      const Color(0xFF8B6240),
      const Color(0xFF7A5535),
      rng.nextDouble(),
    )!;
    canvas.drawRect(rect, Paint()..color = woodBase);

    // — Horizontal wood grain lines —
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 25; i++) {
      final y = rng.nextDouble() * size.height;
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 12) {
        path.lineTo(x, y + (rng.nextDouble() - 0.5) * 3);
      }
      path.lineTo(size.width, y + (rng.nextDouble() - 0.5) * 2);
      final isDark = rng.nextBool();
      grainPaint
        ..color = isDark
            ? const Color(0xFF5C3A1E).withOpacity(0.08 + rng.nextDouble() * 0.12)
            : const Color(0xFFAA8555).withOpacity(0.06 + rng.nextDouble() * 0.08)
        ..strokeWidth = 0.5 + rng.nextDouble() * 1.5;
      canvas.drawPath(path, grainPaint);
    }

    // — Knot holes (1-2 per plank) —
    final knotCount = 1 + rng.nextInt(2);
    for (int i = 0; i < knotCount; i++) {
      final kx = 20 + rng.nextDouble() * (size.width - 40);
      final ky = 8 + rng.nextDouble() * (size.height - 16);
      final kr = 4.0 + rng.nextDouble() * 5;
      // Dark center
      canvas.drawOval(
        Rect.fromCenter(center: Offset(kx, ky), width: kr * 2, height: kr * 1.5),
        Paint()..color = const Color(0xFF3A2210).withOpacity(0.25),
      );
      // Ring around knot
      canvas.drawOval(
        Rect.fromCenter(center: Offset(kx, ky), width: kr * 3, height: kr * 2.2),
        Paint()
          ..color = const Color(0xFF5C3A1E).withOpacity(0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      // Second ring
      canvas.drawOval(
        Rect.fromCenter(center: Offset(kx, ky), width: kr * 4.5, height: kr * 3.2),
        Paint()
          ..color = const Color(0xFF5C3A1E).withOpacity(0.06)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }

    // — Light reflection on top half (bevel) —
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.45),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.transparent,
          ],
        ).createShader(rect),
    );

    // — Dark bottom edge (thickness shadow) —
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.18),
          ],
        ).createShader(rect),
    );

    // — Weathering/wear scratches —
    final scratchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final x1 = rng.nextDouble() * size.width;
      final y1 = rng.nextDouble() * size.height;
      final x2 = x1 + (rng.nextDouble() - 0.5) * 50;
      final y2 = y1 + (rng.nextDouble() - 0.5) * 4;
      scratchPaint
        ..color = Colors.white.withOpacity(0.04 + rng.nextDouble() * 0.06)
        ..strokeWidth = 0.3 + rng.nextDouble() * 0.6;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), scratchPaint);
    }

    // — Nail heads (one on each end) —
    for (final nx in [18.0, size.width - 18.0]) {
      final ny = size.height / 2 + (rng.nextDouble() - 0.5) * 6;
      // Nail shadow
      canvas.drawCircle(
        Offset(nx + 0.5, ny + 1),
        4.5,
        Paint()..color = const Color(0xFF1A0A02).withOpacity(0.3),
      );
      // Nail head
      canvas.drawCircle(
        Offset(nx, ny),
        4,
        Paint()..color = const Color(0xFF4A4040),
      );
      // Nail highlight
      canvas.drawCircle(
        Offset(nx - 1, ny - 1),
        1.5,
        Paint()..color = Colors.white.withOpacity(0.15),
      );
    }

    // — Edge darkening all around —
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [
            Colors.transparent,
            const Color(0xFF1A0A02).withOpacity(0.12),
          ],
        ).createShader(rect),
    );

    canvas.restore();

    // — Outline —
    canvas.drawPath(
      plank,
      Paint()
        ..color = const Color(0xFF3A2210).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints a weathered badge background for the trophy counter
class _WornBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(55);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );

    // Shadow
    canvas.drawRRect(
      rect.shift(const Offset(1, 2)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.25),
    );

    // Base fill — aged parchment
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFCBB48E));

    // Age spots
    canvas.save();
    canvas.clipRRect(rect);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        3 + rng.nextDouble() * 5,
        Paint()..color = const Color(0xFF8B6914).withOpacity(0.06),
      );
    }
    // Dark edges
    canvas.drawRRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF3E2010).withOpacity(0.2),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.restore();

    // Border
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFF5C3317).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
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

    // — Major fold creases (folded in thirds both ways) —
    final creasePaint = Paint()
      ..color = const Color(0xFF6B4A2E).withOpacity(0.15)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final creaseShadow = Paint()
      ..color = const Color(0xFF3E2010).withOpacity(0.08)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    for (final frac in [0.33, 0.5, 0.67]) {
      final y = size.height * frac;
      final p = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 6) {
        p.lineTo(x, y + rng.nextDouble() * 8 - 4);
      }
      canvas.drawPath(p.shift(const Offset(0, 2)), creaseShadow);
      canvas.drawPath(p, creasePaint);
    }
    for (final frac in [0.35, 0.5, 0.65]) {
      final x = size.width * frac;
      final p = Path()..moveTo(x, 0);
      for (double y = 0; y < size.height; y += 6) {
        p.lineTo(x + rng.nextDouble() * 7 - 3.5, y);
      }
      canvas.drawPath(p.shift(const Offset(2, 0)), creaseShadow);
      canvas.drawPath(p, creasePaint);
    }

    // — Diagonal crumple creases (more of them, varying weight) —
    for (int i = 0; i < 15; i++) {
      final x1 = rng.nextDouble() * size.width;
      final y1 = rng.nextDouble() * size.height;
      final len = 50 + rng.nextDouble() * size.width * 0.5;
      final angle = rng.nextDouble() * pi;
      final x2 = x1 + cos(angle) * len;
      final y2 = y1 + sin(angle) * len;
      final path = Path()..moveTo(x1, y1);
      path.quadraticBezierTo(
        (x1 + x2) / 2 + (rng.nextDouble() - 0.5) * 40,
        (y1 + y2) / 2 + (rng.nextDouble() - 0.5) * 40,
        x2, y2,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF6B4A2E).withOpacity(0.04 + rng.nextDouble() * 0.06)
          ..strokeWidth = 0.8 + rng.nextDouble() * 1.5
          ..style = PaintingStyle.stroke,
      );
    }

    // — Water / tea stains (more, bigger, varied) —
    for (int i = 0; i < 20; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 12.0 + rng.nextDouble() * 55;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: r * (0.8 + rng.nextDouble() * 0.8),
          height: r * (0.5 + rng.nextDouble() * 0.7),
        ),
        Paint()
          ..color = Color.lerp(
            const Color(0xFF8B6914),
            const Color(0xFF5C3317),
            rng.nextDouble(),
          )!.withOpacity(0.03 + rng.nextDouble() * 0.05),
      );
    }

    // — Ring stains (two, different sizes) —
    final ringPaint = Paint()
      ..color = const Color(0xFF6B4226).withOpacity(0.09)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.78, size.height * 0.18),
        width: 55, height: 50,
      ),
      ringPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.75),
        width: 40, height: 38,
      ),
      ringPaint..strokeWidth = 2.0,
    );

    // — Heavy paper grain (more dots, varied) —
    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 400; i++) {
      grainPaint.color = Color.lerp(
        const Color(0xFF8B7355),
        const Color(0xFF3E2010),
        rng.nextDouble(),
      )!.withOpacity(0.02 + rng.nextDouble() * 0.04);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 2.0,
        grainPaint,
      );
    }

    // — Worn edge marks (heavier, more numerous) —
    final edgeWearPaint = Paint()..style = PaintingStyle.fill;
    for (int edge = 0; edge < 4; edge++) {
      for (int i = 0; i < 40; i++) {
        edgeWearPaint.color =
            const Color(0xFF3E2010).withOpacity(0.05 + rng.nextDouble() * 0.08);
        final w = 4.0 + rng.nextDouble() * 25;
        final h = 2.0 + rng.nextDouble() * 10;
        Rect r;
        switch (edge) {
          case 0: r = Rect.fromLTWH(rng.nextDouble() * size.width, 0, w, h); break;
          case 1: r = Rect.fromLTWH(rng.nextDouble() * size.width, size.height - h, w, h); break;
          case 2: r = Rect.fromLTWH(0, rng.nextDouble() * size.height, h, w); break;
          default: r = Rect.fromLTWH(size.width - h, rng.nextDouble() * size.height, h, w);
        }
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(2)),
          edgeWearPaint,
        );
      }
    }

    // — Ink bleed marks (like old pen dripped) —
    for (int i = 0; i < 8; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(
        Offset(x, y),
        1.5 + rng.nextDouble() * 3,
        Paint()..color = const Color(0xFF2A1508).withOpacity(0.04 + rng.nextDouble() * 0.04),
      );
      // Drip trail
      canvas.drawLine(
        Offset(x, y),
        Offset(x + (rng.nextDouble() - 0.5) * 5, y + 3 + rng.nextDouble() * 12),
        Paint()
          ..color = const Color(0xFF2A1508).withOpacity(0.03)
          ..strokeWidth = 0.8,
      );
    }

    // — Compass rose (bigger, more detailed) —
    final cp = Paint()
      ..color = const Color(0xFF6B4A2E).withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final cc = Offset(size.width * 0.12, size.height * 0.9);
    const cr = 32.0;
    canvas.drawCircle(cc, cr, cp);
    canvas.drawCircle(cc, cr * 0.6, cp);
    canvas.drawCircle(cc, cr * 0.25, cp..strokeWidth = 0.5);
    // Cardinal lines
    for (final angle in [0.0, pi / 2, pi, 3 * pi / 2]) {
      canvas.drawLine(
        cc + Offset(cos(angle) * cr * 0.2, sin(angle) * cr * 0.2),
        cc + Offset(cos(angle) * (cr + 6), sin(angle) * (cr + 6)),
        cp..strokeWidth = 1.0,
      );
    }
    // Intercardinal lines
    for (final angle in [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4]) {
      canvas.drawLine(
        cc + Offset(cos(angle) * cr * 0.3, sin(angle) * cr * 0.3),
        cc + Offset(cos(angle) * cr * 0.85, sin(angle) * cr * 0.85),
        cp..strokeWidth = 0.5,
      );
    }
    // N arrow
    final nTip = cc + Offset(0, -(cr + 6));
    canvas.drawLine(nTip, nTip + const Offset(-3, 6), cp..strokeWidth = 0.8);
    canvas.drawLine(nTip, nTip + const Offset(3, 6), cp);
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
            const Color(0xFF3E2010).withOpacity(0.3),
            const Color(0xFF2A1508).withOpacity(0.7),
          ],
          stops: const [0.0, 0.55, 0.8, 1.0],
        ).createShader(rect),
    );

    final scorchPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final edge = rng.nextInt(4);
      double x, y;
      switch (edge) {
        case 0: x = rng.nextDouble() * size.width; y = rng.nextDouble() * 12; break;
        case 1: x = rng.nextDouble() * size.width; y = size.height - rng.nextDouble() * 12; break;
        case 2: x = rng.nextDouble() * 12; y = rng.nextDouble() * size.height; break;
        default: x = size.width - rng.nextDouble() * 12; y = rng.nextDouble() * size.height;
      }
      scorchPaint.color = const Color(0xFF1A0E05).withOpacity(0.1 + rng.nextDouble() * 0.15);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: 8 + rng.nextDouble() * 15,
          height: 4 + rng.nextDouble() * 10,
        ),
        scorchPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
