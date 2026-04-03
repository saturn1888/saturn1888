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
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🗺️',
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'OzHunt',
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w700,
                        fontSize: 48,
                        color: AppTheme.warmBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Family Scavenger Hunts!',
                      style: AppTheme.body(size: 18, color: AppTheme.darkGold),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/setup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          foregroundColor: AppTheme.warmBrown,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Text(
                          'Create a Hunt 🗺️',
                          style: AppTheme.heading(size: 22, color: AppTheme.warmBrown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/play-select'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.adventureGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Text(
                          'Play a Hunt 🎯',
                          style: AppTheme.heading(size: 22, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Trophy>('trophies').listenable(),
                builder: (context, Box<Trophy> box, _) {
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, '/trophies'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.gold),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 24)),
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
    );
  }
}
