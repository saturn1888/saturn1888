import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A primary button styled like a wooden plank — used for main actions across all screens
class WoodButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const WoodButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? const Color(0xFF9A6B40);
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0,
        child: CustomPaint(
          painter: _WoodButtonPainter(baseColor: baseColor),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: const Color(0xFFFFE0A0), size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTheme.heading(
                    size: 18,
                    color: const Color(0xFFFFE0A0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WoodButtonPainter extends CustomPainter {
  final Color baseColor;
  _WoodButtonPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(baseColor.value);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final path = Path();
    const jag = 1.0;
    const step = 6.0;
    const r = 8.0;

    path.moveTo(r, rng.nextDouble() * jag);
    for (double x = r; x < size.width - r; x += step) {
      path.lineTo(x, rng.nextDouble() * jag);
    }
    path.lineTo(size.width, r);
    for (double y = r; y < size.height - r; y += step) {
      path.lineTo(size.width - rng.nextDouble() * jag, y);
    }
    path.lineTo(size.width - r, size.height);
    for (double x = size.width - r; x > r; x -= step) {
      path.lineTo(x, size.height - rng.nextDouble() * jag);
    }
    path.lineTo(0, size.height - r);
    for (double y = size.height - r; y > r; y -= step) {
      path.lineTo(rng.nextDouble() * jag, y);
    }
    path.close();

    // Shadow
    canvas.drawPath(
      path.shift(const Offset(2, 3)),
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // Grain
    final grain = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 12; i++) {
      final y = rng.nextDouble() * size.height;
      final p = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 10) {
        p.lineTo(x, y + (rng.nextDouble() - 0.5) * 2);
      }
      grain
        ..color = (rng.nextBool()
                ? const Color(0xFF5C3A1E)
                : const Color(0xFFC09560))
            .withOpacity(0.06 + rng.nextDouble() * 0.06)
        ..strokeWidth = 0.4 + rng.nextDouble() * 0.8;
      canvas.drawPath(p, grain);
    }

    // Top highlight
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.4),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.1), Colors.transparent],
        ).createShader(rect),
    );

    // Bottom shadow
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
        ).createShader(rect),
    );

    canvas.restore();

    // Outline
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A card styled like aged parchment paper
class ParchmentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;

  const ParchmentCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4C4A8).withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}

/// Section header with decorative line
class AdventureHeader extends StatelessWidget {
  final String title;
  final String? emoji;

  const AdventureHeader({
    super.key,
    required this.title,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
          ],
          Text(title, style: AppTheme.heading(size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkGold.withOpacity(0.4),
                    AppTheme.darkGold.withOpacity(0.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
