import 'dart:math';
import 'package:flutter/material.dart';

/// Clean modern background with subtle adventure warmth.
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
            Color(0xFFF7F1E8),
            Color(0xFFF3ECE0),
            Color(0xFFF0E8DA),
          ],
        ),
      ),
      child: Stack(
        children: [
          if (showTexture)
            Positioned.fill(
              child: CustomPaint(painter: _SubtleTexturePainter()),
            ),
          child,
        ],
      ),
    );
  }
}

/// Very subtle texture — just enough to feel warm, not distracting
class _SubtleTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    // Very faint paper grain
    for (int i = 0; i < 80; i++) {
      paint.color = const Color(0xFFD4C4A8).withOpacity(0.015 + rng.nextDouble() * 0.01);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.5 + rng.nextDouble() * 1.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
