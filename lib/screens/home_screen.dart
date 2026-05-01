import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/illustrations.dart';
import '../models/trophy.dart';
import '../theme/app_theme.dart';
import '../widgets/music_controller.dart';
import '../widgets/mute_button.dart';
import '../widgets/adventure_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  // Float animation
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Button entrance
  late AnimationController _entranceController;
  late CurvedAnimation _btn1, _btn2, _btn3;

  // Twinkling stars
  final List<double> _starOpacities = List.generate(20, (_) => 0.3);
  late List<Offset> _starPositions;
  late List<double> _starSizes;
  Timer? _starTimer;

  @override
  void initState() {
    super.initState();
    MusicController.instance.start();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _btn1 = CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic));
    _btn2 = CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.75, curve: Curves.easeOutCubic));
    _btn3 = CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.30, 0.90, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceController.forward();
    });

    final rng = math.Random();
    _starPositions = List.generate(
        20, (_) => Offset(rng.nextDouble() * 400, rng.nextDouble() * 900));
    _starSizes = List.generate(20, (_) => 1.5 + rng.nextDouble() * 2.0);
    _starTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (!mounted) return;
      final r = math.Random();
      setState(() {
        for (int j = 0; j < 3; j++) {
          final idx = r.nextInt(20);
          _starOpacities[idx] = r.nextBool() ? 0.08 : 0.6;
        }
      });
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _entranceController.dispose();
    _starTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.background,
        child: SafeArea(
          child: Stack(
            children: [
              // Twinkling stars
              ...List.generate(20, (i) => Positioned(
                    left: _starPositions[i].dx,
                    top: _starPositions[i].dy,
                    child: AnimatedOpacity(
                      opacity: _starOpacities[i],
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        width: _starSizes[i],
                        height: _starSizes[i],
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )),
              // Main content
              Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Floating hero image
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.15),
                                blurRadius: 40,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              Illustrations.appIcon,
                              width: 260,
                              height: 260,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, __, ___) => Container(
                                width: 260,
                                height: 260,
                                color: AppTheme.surfaceHigh,
                                child: Center(
                                  child: Text('OzHunt',
                                      style: AppTheme.heading(size: 32)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Buttons with entrance animation
                      FadeTransition(
                        opacity: _btn1,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(_btn1),
                          child: GradientButton.quickPlay(
                            label: 'QUICK PLAY',
                            icon: Icons.bolt,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/quick-play'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _btn2,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(_btn2),
                          child: GradientButton.create(
                            label: 'CREATE A HUNT',
                            icon: Icons.add_circle_outline,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/setup'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _btn3,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(_btn3),
                          child: GradientButton.join(
                            label: 'JOIN A HUNT',
                            icon: Icons.group_add,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/join-hunt'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Rank strip
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Trophy>('trophies').listenable(),
                        builder: (context, Box<Trophy> box, _) {
                          final count = box.length;
                          String tier;
                          int nextTarget;
                          if (count >= 25) {
                            tier = 'MASTER EXPLORER';
                            nextTarget = count;
                          } else if (count >= 10) {
                            tier = 'GOLD HUNTER';
                            nextTarget = 25;
                          } else if (count >= 5) {
                            tier = 'SILVER HUNTER';
                            nextTarget = 10;
                          } else if (count >= 1) {
                            tier = 'BRONZE HUNTER';
                            nextTarget = 5;
                          } else {
                            tier = 'ROOKIE';
                            nextTarget = 1;
                          }
                          return GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/trophies'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Illustrations.progressionBadge(count),
                                    width: 32,
                                    height: 32,
                                    errorBuilder: (_, __, ___) =>
                                        const Text('⭐',
                                            style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(tier,
                                      style: AppTheme.heading(
                                          size: 14,
                                          color: AppTheme.tertiary)),
                                  const Spacer(),
                                  Text('$count pts',
                                      style: AppTheme.body(
                                          size: 13,
                                          color: AppTheme.onSurface)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Nav links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _navItem('My Hunts', Icons.list_alt, () =>
                              Navigator.pushNamed(context, '/play-select')),
                          _navItem('Manage', Icons.tune, () =>
                              Navigator.pushNamed(context, '/manage')),
                          _navItem('Trophies', Icons.emoji_events, () =>
                              Navigator.pushNamed(context, '/trophies')),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Mute button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const MuteButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: AppTheme.onSurfaceVariant),
          const SizedBox(height: 4),
          Text(label,
              style: AppTheme.caption(size: 11)),
        ],
      ),
    );
  }
}

/// Helper for animations
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}
