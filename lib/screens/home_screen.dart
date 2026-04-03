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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4B896),
              Color(0xFFC4A97D),
              Color(0xFFBE9B6B),
              Color(0xFFD2B48C),
              Color(0xFFC4A97D),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
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
              // Darkened edges for old map look
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        Colors.transparent,
                        Colors.brown.withOpacity(0.3),
                      ],
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
                      // Logo image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/ozhunt_logo.png',
                          width: 260,
                          height: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image not found
                            return Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                color: AppTheme.warmBrown.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/manage'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppTheme.warmBrown.withOpacity(0.6),
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Manage Hunts 📋',
                            style: AppTheme.heading(
                                size: 20, color: AppTheme.warmBrown),
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
                          color: const Color(0xFFD4B896).withOpacity(0.8),
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

/// Paints subtle lines and spots to simulate aged parchment/map texture
class _MapTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.06)
      ..strokeWidth = 1;

    // Horizontal creases
    for (double y = 0; y < size.height; y += size.height / 5) {
      canvas.drawLine(
        Offset(0, y + 10),
        Offset(size.width, y - 5),
        paint..color = Colors.brown.withOpacity(0.08),
      );
    }

    // Vertical creases
    for (double x = 0; x < size.width; x += size.width / 4) {
      canvas.drawLine(
        Offset(x + 5, 0),
        Offset(x - 8, size.height),
        paint..color = Colors.brown.withOpacity(0.06),
      );
    }

    // Aged spots
    final spotPaint = Paint()..color = Colors.brown.withOpacity(0.04);
    final spots = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.15, size.height * 0.9),
      Offset(size.width * 0.9, size.height * 0.6),
    ];
    for (final spot in spots) {
      canvas.drawCircle(spot, 25, spotPaint);
    }

    // Edge darkening strokes
    final edgePaint = Paint()
      ..color = Colors.brown.withOpacity(0.1)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), edgePaint);
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), edgePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
