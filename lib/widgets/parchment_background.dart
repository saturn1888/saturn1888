import 'dart:math';
import 'package:flutter/material.dart';

/// Wraps any screen content with the parchment/treasure map background.
/// Use this as the body of a Scaffold, or wrap a Scaffold with it.
class ParchmentBackground extends StatelessWidget {
  final Widget child;
  final bool showTexture;

  const ParchmentBackground({
    super.key,
    required this.child,
    this.showTexture = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          if (showTexture)
            Positioned.fill(
              child: CustomPaint(painter: _LightTexturePainter()),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.95,
                  colors: [
                    Colors.transparent,
                    Colors.brown.withOpacity(0.02),
                    Colors.brown.withOpacity(0.08),
                    Colors.brown.withOpacity(0.2),
                  ],
                  stops: const [0.5, 0.7, 0.85, 1.0],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// A lighter version of the map texture for inner screens — fold creases,
/// paper grain, and subtle stains without overwhelming the content.
class _LightTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);

    // Fold creases
    final creasePaint = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final frac in [0.33, 0.67]) {
      final y = size.height * frac;
      final p = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 8) {
        p.lineTo(x, y + rng.nextDouble() * 4 - 2);
      }
      canvas.drawPath(p, creasePaint);
    }
    for (final frac in [0.5]) {
      final x = size.width * frac;
      final p = Path()..moveTo(x, 0);
      for (double y = 0; y < size.height; y += 8) {
        p.lineTo(x + rng.nextDouble() * 4 - 2, y);
      }
      canvas.drawPath(p, creasePaint);
    }

    // Paper grain
    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 150; i++) {
      grainPaint.color =
          const Color(0xFF8B7355).withOpacity(0.01 + rng.nextDouble() * 0.02);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 1.2,
        grainPaint,
      );
    }

    // A few subtle stains
    for (int i = 0; i < 6; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
              rng.nextDouble() * size.width, rng.nextDouble() * size.height),
          width: (8 + rng.nextDouble() * 30),
          height: (6 + rng.nextDouble() * 20),
        ),
        Paint()
          ..color = const Color(0xFF8B6914)
              .withOpacity(0.015 + rng.nextDouble() * 0.02),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
