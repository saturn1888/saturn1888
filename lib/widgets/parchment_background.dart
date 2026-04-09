import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Deep navy background with subtle star particles
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
            Color(0xFF141850),
            Color(0xFF1A1F5E),
            Color(0xFF1E2468),
            Color(0xFF1A1F5E),
          ],
        ),
      ),
      child: Stack(
        children: [
          if (showTexture)
            Positioned.fill(
              child: CustomPaint(painter: _StarFieldPainter()),
            ),
          child,
        ],
      ),
    );
  }
}

/// Subtle twinkling star dots
class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = 0.3 + rng.nextDouble() * 1.2;
      final opacity = 0.05 + rng.nextDouble() * 0.15;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
