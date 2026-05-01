import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Deep space background with subtle star particles
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
      color: AppTheme.background,
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

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 50; i++) {
      paint.color = Colors.white.withOpacity(0.02 + rng.nextDouble() * 0.08);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 1.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
