import 'dart:math';
import 'package:flutter/material.dart';
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
          // Parchment/old map gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD9C4A5),
              Color(0xFFCBB48E),
              Color(0xFFC1A676),
              Color(0xFFB89A68),
              Color(0xFFCBB48E),
            ],
            stops: [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Parchment texture overlay using subtle pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapTexturePainter(),
                ),
              ),
              // Burned / aged edge vignette — heavier at corners
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.95,
                      colors: [
                        Colors.transparent,
                        Colors.brown.withOpacity(0.08),
                        Colors.brown.withOpacity(0.25),
                        Colors.brown.withOpacity(0.55),
                      ],
                      stops: const [0.4, 0.65, 0.85, 1.0],
                    ),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // Logo image with torn map edges
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
                                      Text(
                                        'OzHunt',
                                        style: AppTheme.heading(
                                            size: 32, color: AppTheme.warmBrown),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Family Scavenger Hunts!',
                        style: AppTheme.body(
                          size: 18,
                          color: AppTheme.warmBrown,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/setup'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: AppTheme.warmBrown,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 6,
                            shadowColor: Colors.brown.withOpacity(0.5),
                          ),
                          child: Text(
                            'Create a Hunt 🗺️',
                            style: AppTheme.heading(
                                size: 22, color: AppTheme.warmBrown),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/play-select'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.adventureGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 6,
                            shadowColor: Colors.brown.withOpacity(0.5),
                          ),
                          child: Text(
                            'Play a Hunt 🎯',
                            style: AppTheme.heading(
                                size: 22, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/manage'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.leather,
                            foregroundColor: const Color(0xFFF5DEB3),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 4,
                            shadowColor: Colors.brown.withOpacity(0.4),
                          ),
                          child: Text(
                            'Manage Hunts 📋',
                            style: AppTheme.heading(
                                size: 20, color: const Color(0xFFF5DEB3)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Trophy>('trophies').listenable(),
                  builder: (context, Box<Trophy> box, _) {
                    return InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/trophies'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9C4A5).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.warmBrown),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🏆',
                                style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 6),
                            Text(
                              '${box.length}',
                              style: AppTheme.heading(size: 20),
                            ),
                          ],
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

/// Paints creases, stains, grain, and wear to look like a crumpled old treasure map
class _MapTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42); // Fixed seed for consistent texture

    // — Major fold creases (the map was folded in quarters) —
    final creasePaint = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.12)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Horizontal fold
    final hFold = size.height * 0.48;
    final hPath = Path()..moveTo(0, hFold - 3);
    for (double x = 0; x < size.width; x += 8) {
      hPath.lineTo(x, hFold + rng.nextDouble() * 6 - 3);
    }
    canvas.drawPath(hPath, creasePaint);
    // Shadow below the fold
    canvas.drawPath(
      hPath.shift(const Offset(0, 2)),
      Paint()
        ..color = const Color(0xFF5C3317).withOpacity(0.06)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );

    // Vertical fold
    final vFold = size.width * 0.5;
    final vPath = Path()..moveTo(vFold - 2, 0);
    for (double y = 0; y < size.height; y += 8) {
      vPath.lineTo(vFold + rng.nextDouble() * 5 - 2.5, y);
    }
    canvas.drawPath(vPath, creasePaint);
    canvas.drawPath(
      vPath.shift(const Offset(2, 0)),
      Paint()
        ..color = const Color(0xFF5C3317).withOpacity(0.05)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // — Diagonal crumple creases —
    final crumplePaint = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.07)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final x1 = rng.nextDouble() * size.width;
      final y1 = rng.nextDouble() * size.height;
      final x2 = x1 + (rng.nextDouble() - 0.5) * size.width * 0.6;
      final y2 = y1 + (rng.nextDouble() - 0.5) * size.height * 0.4;
      final path = Path()..moveTo(x1, y1);
      final cx = (x1 + x2) / 2 + (rng.nextDouble() - 0.5) * 30;
      final cy = (y1 + y2) / 2 + (rng.nextDouble() - 0.5) * 30;
      path.quadraticBezierTo(cx, cy, x2, y2);
      canvas.drawPath(path, crumplePaint);
    }

    // — Water / tea stains —
    for (int i = 0; i < 12; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 15.0 + rng.nextDouble() * 40;
      final stainPaint = Paint()
        ..color = Color.lerp(
          const Color(0xFF8B6914),
          const Color(0xFF6B4226),
          rng.nextDouble(),
        )!.withOpacity(0.03 + rng.nextDouble() * 0.04);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: r * (1.0 + rng.nextDouble() * 0.5),
          height: r * (0.7 + rng.nextDouble() * 0.6),
        ),
        stainPaint,
      );
    }

    // — Ring stain (like a coffee/tea cup was placed on the map) —
    final ringPaint = Paint()
      ..color = const Color(0xFF7B5B3A).withOpacity(0.08)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.2),
        width: 60,
        height: 55,
      ),
      ringPaint,
    );

    // — Paper grain (tiny dots scattered everywhere) —
    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 200; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      grainPaint.color = Color.lerp(
        const Color(0xFF8B7355),
        const Color(0xFF5C3317),
        rng.nextDouble(),
      )!.withOpacity(0.02 + rng.nextDouble() * 0.03);
      canvas.drawCircle(Offset(x, y), 0.5 + rng.nextDouble() * 1.5, grainPaint);
    }

    // — Worn edge marks (darker strokes near all 4 edges) —
    final edgeWearPaint = Paint()
      ..style = PaintingStyle.fill;
    // Top edge
    for (int i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final w = 5.0 + rng.nextDouble() * 20;
      final h = 2.0 + rng.nextDouble() * 8;
      edgeWearPaint.color = const Color(0xFF5C3317).withOpacity(0.04 + rng.nextDouble() * 0.06);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 0, w, h),
          const Radius.circular(2),
        ),
        edgeWearPaint,
      );
    }
    // Bottom edge
    for (int i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final w = 5.0 + rng.nextDouble() * 20;
      final h = 2.0 + rng.nextDouble() * 8;
      edgeWearPaint.color = const Color(0xFF5C3317).withOpacity(0.04 + rng.nextDouble() * 0.06);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, w, h),
          const Radius.circular(2),
        ),
        edgeWearPaint,
      );
    }
    // Left edge
    for (int i = 0; i < 20; i++) {
      final y = rng.nextDouble() * size.height;
      final w = 2.0 + rng.nextDouble() * 6;
      final h = 5.0 + rng.nextDouble() * 15;
      edgeWearPaint.color = const Color(0xFF5C3317).withOpacity(0.03 + rng.nextDouble() * 0.05);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, y, w, h),
          const Radius.circular(2),
        ),
        edgeWearPaint,
      );
    }
    // Right edge
    for (int i = 0; i < 20; i++) {
      final y = rng.nextDouble() * size.height;
      final w = 2.0 + rng.nextDouble() * 6;
      final h = 5.0 + rng.nextDouble() * 15;
      edgeWearPaint.color = const Color(0xFF5C3317).withOpacity(0.03 + rng.nextDouble() * 0.05);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width - w, y, w, h),
          const Radius.circular(2),
        ),
        edgeWearPaint,
      );
    }

    // — Faded "compass rose" hint in corner —
    final compassPaint = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.06)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final cc = Offset(size.width * 0.12, size.height * 0.88);
    const cr = 28.0;
    canvas.drawCircle(cc, cr, compassPaint);
    canvas.drawCircle(cc, cr * 0.6, compassPaint);
    // N-S-E-W lines
    canvas.drawLine(cc - const Offset(0, cr + 5), cc + const Offset(0, cr + 5), compassPaint);
    canvas.drawLine(cc - const Offset(cr + 5, 0), cc + const Offset(cr + 5, 0), compassPaint);
    // Diagonal lines
    final diag = cr * 0.7;
    canvas.drawLine(cc - Offset(diag, diag), cc + Offset(diag, diag), compassPaint..strokeWidth = 0.5);
    canvas.drawLine(cc - Offset(-diag, diag), cc + Offset(-diag, diag), compassPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Clips the logo with jagged torn-paper edges
class _TornEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final rng = Random(77);
    final path = Path();
    const inset = 6.0;   // How far in from the edge the tears start
    const jag = 5.0;     // Max depth of each tear
    const step = 4.0;    // Distance between tear points

    // Top edge: left to right
    path.moveTo(inset + rng.nextDouble() * jag, inset + rng.nextDouble() * jag);
    for (double x = inset; x < size.width - inset; x += step) {
      path.lineTo(x, inset + rng.nextDouble() * jag * 2);
    }

    // Right edge: top to bottom
    for (double y = inset; y < size.height - inset; y += step) {
      path.lineTo(size.width - inset - rng.nextDouble() * jag * 2, y);
    }

    // Bottom edge: right to left
    for (double x = size.width - inset; x > inset; x -= step) {
      path.lineTo(x, size.height - inset - rng.nextDouble() * jag * 2);
    }

    // Left edge: bottom to top
    for (double y = size.height - inset; y > inset; y -= step) {
      path.lineTo(inset + rng.nextDouble() * jag * 2, y);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Paints burned/darkened edges and wear marks on top of the clipped logo
class _TornEdgeOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(99);

    // Dark burned border vignette
    final borderPaint = Paint()
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
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    // Scorch marks near edges
    final scorchPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final onEdge = rng.nextInt(4);
      double x, y;
      switch (onEdge) {
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
