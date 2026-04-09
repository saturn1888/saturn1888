import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Button entrance animation
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

    // Float
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Entrance
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

    // Stars
    final rng = math.Random();
    _starPositions = List.generate(
        20, (_) => Offset(rng.nextDouble() * 400, rng.nextDouble() * 900));
    _starSizes =
        List.generate(20, (_) => 1.5 + rng.nextDouble() * 2.0);
    _starTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (!mounted) return;
      final r = math.Random();
      setState(() {
        for (int j = 0; j < 3; j++) {
          final idx = r.nextInt(20);
          _starOpacities[idx] = r.nextBool() ? 0.1 : 0.9;
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

  Widget _textLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: AppTheme.body(
            size: 14,
            color: AppTheme.warmBrown.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _dividerDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text('•',
          style: TextStyle(
              color: AppTheme.warmBrown.withOpacity(0.3), fontSize: 14)),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave OzHunt?', style: AppTheme.heading(size: 22)),
        content: Text(
          'Are you sure you want to exit the app?',
          style: AppTheme.body(size: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Stay', style: AppTheme.body(size: 16, color: AppTheme.darkGold)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Stack(
            children: [
              // Static star field
              Positioned.fill(
                child: CustomPaint(painter: _StarFieldPainter()),
              ),
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
              Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Hero image with glow + float
                      _AnimatedBuilder(animation:
                        animation: _floatAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        ),
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xCCD4A04A),
                              blurRadius: 40,
                              spreadRadius: -4,
                            ),
                            BoxShadow(
                              color: Color(0xFF1A1F5E),
                              blurRadius: 0,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            Illustrations.appIcon,
                            width: 280,
                            height: 280,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) =>
                                const Text('🗺️',
                                    style: TextStyle(fontSize: 80)),
                          ),
                        ),
                      ),
                      ), // AnimatedBuilder
                      const SizedBox(height: 20),
                      // Gradient buttons with entrance animation
                      FadeTransition(
                        opacity: _btn1,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(_btn1),
                          child: GradientButton.quickPlay(
                            label: 'Quick Play',
                            icon: Icons.play_arrow_rounded,
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
                            label: 'Create a Hunt',
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
                            label: 'Join a Hunt',
                            icon: Icons.group_add,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/join-hunt'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Rank strip — between buttons and nav
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Trophy>('trophies').listenable(),
                        builder: (context, Box<Trophy> box, _) {
                          final count = box.length;
                          String tier;
                          int nextTarget;
                          if (count >= 25) {
                            tier = 'Master Explorer';
                            nextTarget = count;
                          } else if (count >= 10) {
                            tier = 'Gold Hunter';
                            nextTarget = 25;
                          } else if (count >= 5) {
                            tier = 'Silver Hunter';
                            nextTarget = 10;
                          } else if (count >= 1) {
                            tier = 'Bronze Hunter';
                            nextTarget = 5;
                          } else {
                            tier = 'Rookie';
                            nextTarget = 1;
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('⭐',
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 6),
                                    Text(tier,
                                        style: AppTheme.heading(
                                            size: 13,
                                            color: AppTheme.gold)),
                                    const Spacer(),
                                    Text('$count pts',
                                        style: AppTheme.body(
                                            size: 12,
                                            color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: nextTarget > 0
                                        ? count / nextTarget
                                        : 1.0,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.15),
                                    valueColor:
                                        const AlwaysStoppedAnimation(
                                            AppTheme.gold),
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      // Secondary links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _navChip('My Hunts', Icons.list, () =>
                              Navigator.pushNamed(context, '/play-select')),
                          const SizedBox(width: 8),
                          _navChip('Manage', Icons.settings, () =>
                              Navigator.pushNamed(context, '/manage')),
                          const SizedBox(width: 8),
                          _navChip('Trophies', Icons.emoji_events, () =>
                              Navigator.pushNamed(context, '/trophies')),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              // Mute button top-left
              Positioned(
                top: 8,
                left: 8,
                child: const MuteButton(),
              ),
              // Gold sparkles around hero
              const Positioned(
                top: 50, right: 40,
                child: _GoldSparkle(size: 14, delayMs: 0),
              ),
              const Positioned(
                top: 110, left: 30,
                child: _GoldSparkle(size: 10, delayMs: 600),
              ),
              const Positioned(
                top: 200, right: 50,
                child: _GoldSparkle(size: 12, delayMs: 1200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navChip(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.textMuted),
            const SizedBox(width: 4),
            Text(label, style: AppTheme.caption(size: 12)),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  const _AnimatedBuilder({
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}

/// Gold 4-point sparkle that scales up and fades
class _GoldSparkle extends StatefulWidget {
  final double size;
  final int delayMs;
  const _GoldSparkle({this.size = 12, this.delayMs = 0});

  @override
  State<_GoldSparkle> createState() => _GoldSparkleState();
}

class _GoldSparkleState extends State<_GoldSparkle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  Timer? _loopTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scale = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(_ctrl);

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (!mounted) return;
      _runLoop();
    });
  }

  void _runLoop() {
    _ctrl.forward(from: 0);
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final delay = 500 + math.Random().nextInt(1500);
        _loopTimer = Timer(Duration(milliseconds: delay), () {
          if (mounted) _ctrl.forward(from: 0);
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _loopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedBuilder(animation:
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: widget.size,
                    height: 2,
                    color: const Color(0xFFFFD23F),
                  ),
                ),
                Transform.rotate(
                  angle: -math.pi / 4,
                  child: Container(
                    width: widget.size,
                    height: 2,
                    color: const Color(0xFFFFD23F),
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

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 80; i++) {
      paint.color = Colors.white.withOpacity(0.03 + rng.nextDouble() * 0.12);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A tilted wooden signpost plank with golden text
class _SignpostPlank extends StatelessWidget {
  final String label;
  final double tilt;
  final int arrowDirection; // 1 = right, -1 = left, 0 = no arrow
  final int seed;
  final VoidCallback onTap;

  const _SignpostPlank({
    required this.label,
    required this.tilt,
    required this.arrowDirection,
    required this.seed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: tilt,
        child: CustomPaint(
          painter: _SignpostPlankPainter(
            seed: seed,
            arrowDirection: arrowDirection,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: arrowDirection == -1 ? 32 : 20,
              right: arrowDirection == 1 ? 32 : 20,
            ),
            alignment: Alignment.center,
            child: _GoldenCarvedText(label: label, seed: seed),
          ),
        ),
      ),
    );
  }
}

/// Golden text with slight roughness — like painted/burned onto wood
class _GoldenCarvedText extends StatelessWidget {
  final String label;
  final int seed;
  final double fontSize;
  const _GoldenCarvedText({
    required this.label,
    required this.seed,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final rng = Random(seed * 31 + label.hashCode);
    final upper = label.toUpperCase();
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dark shadow behind text
        Transform.translate(
          offset: const Offset(1.0, 1.5),
          child: Text(
            upper,
            textAlign: TextAlign.center,
            style: GoogleFonts.specialElite(
              fontSize: fontSize,
              color: Colors.black.withOpacity(0.5),
              letterSpacing: 1.2,
            ),
          ),
        ),
        // Individual letters with slight wobble
        Wrap(
          alignment: WrapAlignment.center,
          children: upper.split('').map((char) {
            final dy = (rng.nextDouble() - 0.5) * 2.0;
            final dx = (rng.nextDouble() - 0.5) * 0.8;
            final rotation = (rng.nextDouble() - 0.5) * 0.04;
            final sizeVar = fontSize + (rng.nextDouble() - 0.5) * 2.5;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.rotate(
                angle: rotation,
                child: Text(
                  char,
                  style: GoogleFonts.specialElite(
                    fontSize: sizeVar,
                    color: const Color(0xFFFFD480),
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFF8C00).withOpacity(0.4),
                        blurRadius: 3,
                      ),
                    ],
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

/// Paints a wooden signpost plank with arrow-shaped end, grain, and nail
class _SignpostPlankPainter extends CustomPainter {
  final int seed;
  final int arrowDirection;
  _SignpostPlankPainter({required this.seed, required this.arrowDirection});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed * 7919);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // — Build plank shape with pointed arrow end —
    final plank = Path();
    const jag = 1.5;
    const step = 5.0;
    final arrowDepth = 18.0;
    final midY = size.height / 2;

    if (arrowDirection == 0) {
      // Plain rectangular plank — no arrow
      plank.moveTo(4, rng.nextDouble() * jag);
      for (double x = 4; x < size.width - 4; x += step) {
        plank.lineTo(x, rng.nextDouble() * jag);
      }
      plank.lineTo(size.width, rng.nextDouble() * jag * 2);
      plank.lineTo(size.width, size.height - rng.nextDouble() * jag * 2);
      for (double x = size.width - 4; x > 4; x -= step) {
        plank.lineTo(x, size.height - rng.nextDouble() * jag);
      }
      plank.lineTo(0, size.height - rng.nextDouble() * jag * 2);
      plank.lineTo(0, rng.nextDouble() * jag * 2);
    } else if (arrowDirection == 1) {
      // Point on the right side
      plank.moveTo(4, rng.nextDouble() * jag);
      for (double x = 4; x < size.width - arrowDepth; x += step) {
        plank.lineTo(x, rng.nextDouble() * jag);
      }
      plank.lineTo(size.width - arrowDepth, 0);
      plank.lineTo(size.width, midY);
      plank.lineTo(size.width - arrowDepth, size.height);
      for (double x = size.width - arrowDepth; x > 4; x -= step) {
        plank.lineTo(x, size.height - rng.nextDouble() * jag);
      }
      plank.lineTo(0, size.height - rng.nextDouble() * jag * 2);
      plank.lineTo(0, rng.nextDouble() * jag * 2);
    } else {
      // Point on the left side
      plank.moveTo(arrowDepth, rng.nextDouble() * jag);
      for (double x = arrowDepth; x < size.width - 4; x += step) {
        plank.lineTo(x, rng.nextDouble() * jag);
      }
      plank.lineTo(size.width, rng.nextDouble() * jag * 2);
      plank.lineTo(size.width, size.height - rng.nextDouble() * jag * 2);
      for (double x = size.width - 4; x > arrowDepth; x -= step) {
        plank.lineTo(x, size.height - rng.nextDouble() * jag);
      }
      plank.lineTo(arrowDepth, size.height);
      plank.lineTo(0, midY);
      plank.lineTo(arrowDepth, 0);
    }
    plank.close();

    // — Drop shadow —
    canvas.drawPath(
      plank.shift(const Offset(3, 4)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.3),
    );

    // — Wood fill —
    canvas.save();
    canvas.clipPath(plank);

    // Warm bright wood base
    final woodBase = Color.lerp(
      const Color(0xFFA87840),
      const Color(0xFF9A6B35),
      rng.nextDouble(),
    )!;
    canvas.drawRect(rect, Paint()..color = woodBase);

    // — Horizontal wood grain —
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 20; i++) {
      final y = rng.nextDouble() * size.height;
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 10) {
        path.lineTo(x, y + (rng.nextDouble() - 0.5) * 2.5);
      }
      final isDark = rng.nextBool();
      grainPaint
        ..color = isDark
            ? const Color(0xFF6B4A2E).withOpacity(0.10 + rng.nextDouble() * 0.10)
            : const Color(0xFFC09560).withOpacity(0.08 + rng.nextDouble() * 0.10)
        ..strokeWidth = 0.5 + rng.nextDouble() * 1.2;
      canvas.drawPath(path, grainPaint);
    }

    // — Knot (one per plank) —
    final kx = 30 + rng.nextDouble() * (size.width - 60);
    final ky = 6 + rng.nextDouble() * (size.height - 12);
    final kr = 3.0 + rng.nextDouble() * 4;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(kx, ky), width: kr * 2, height: kr * 1.4),
      Paint()..color = const Color(0xFF5C3A1E).withOpacity(0.2),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(kx, ky), width: kr * 3.5, height: kr * 2.5),
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // — Top bevel highlight —
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.4),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.transparent,
          ],
        ).createShader(rect),
    );

    // — Bottom shadow for thickness —
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.75, size.width, size.height * 0.25),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.15),
          ],
        ).createShader(rect),
    );

    // — Scratches —
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        Paint()
          ..color = Colors.white.withOpacity(0.04 + rng.nextDouble() * 0.05)
          ..strokeWidth = 0.4,
      );
    }

    // — Nail hole (near the non-arrow end) —
    final nailX = arrowDirection == 0
        ? size.width / 2
        : arrowDirection == 1 ? 14.0 : size.width - 14.0;
    final nailY = midY;
    canvas.drawCircle(
      Offset(nailX + 0.5, nailY + 1),
      4.5,
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.35),
    );
    canvas.drawCircle(
      Offset(nailX, nailY),
      4,
      Paint()..color = const Color(0xFF3A3535),
    );
    canvas.drawCircle(
      Offset(nailX - 1, nailY - 1),
      1.5,
      Paint()..color = Colors.white.withOpacity(0.18),
    );

    // — Edge vignette —
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [
            Colors.transparent,
            const Color(0xFF3E2010).withOpacity(0.10),
          ],
        ).createShader(rect),
    );

    canvas.restore();

    // — Outline —
    canvas.drawPath(
      plank,
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Weathered badge for trophy counter
class _WornBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(55);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      rect.shift(const Offset(1, 2)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.2),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFD9C4A5));
    canvas.save();
    canvas.clipRRect(rect);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        3 + rng.nextDouble() * 5,
        Paint()..color = const Color(0xFF8B6914).withOpacity(0.06),
      );
    }
    canvas.restore();
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFF5C3317).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints a wooden sign hanging from two worn ropes connected to the logo above
class _HangingSignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(88);
    final w = size.width;
    final h = size.height;

    // Rope attachment points — top at logo corners, bottom at plank edges
    // Logo is 270px wide centred in 300px, so corners at ~15 and ~285
    final ropeTopLeftX = 15.0;
    final ropeTopRightX = w - 15.0;
    const ropeTopY = 0.0;
    final plankTop = h * 0.22;
    final plankLeftRopeX = 24.0;
    final plankRightRopeX = w - 24.0;

    // — Draw ropes (behind the plank) —
    final ropePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Left rope — 5 strands twisted for thick worn rope
    for (int strand = 0; strand < 5; strand++) {
      final strandOffset = (strand - 2) * 1.3;
      // Twist effect — each strand wobbles slightly
      final twistPhase = strand * 0.8;
      final ropePath = Path()..moveTo(ropeTopLeftX + strandOffset, ropeTopY);
      final steps = 12;
      for (int i = 1; i <= steps; i++) {
        final t = i / steps;
        // Lerp from top to bottom with sag
        final x = ropeTopLeftX + (plankLeftRopeX - ropeTopLeftX) * t +
            sin(t * pi + twistPhase) * 3 + strandOffset;
        final y = ropeTopY + (plankTop + 2 - ropeTopY) * t +
            sin(t * pi) * 6; // sag
        ropePath.lineTo(x, y);
      }
      ropePaint
        ..color = Color.lerp(
          const Color(0xFF9B8060),
          const Color(0xFF6B5030),
          rng.nextDouble(),
        )!.withOpacity(0.5 + rng.nextDouble() * 0.4)
        ..strokeWidth = 2.5 - (strand - 2).abs() * 0.4;
      canvas.drawPath(ropePath, ropePaint);
    }

    // Right rope — 5 strands
    for (int strand = 0; strand < 5; strand++) {
      final strandOffset = (strand - 2) * 1.3;
      final twistPhase = strand * 0.8;
      final ropePath = Path()..moveTo(ropeTopRightX + strandOffset, ropeTopY);
      final steps = 12;
      for (int i = 1; i <= steps; i++) {
        final t = i / steps;
        final x = ropeTopRightX + (plankRightRopeX - ropeTopRightX) * t +
            sin(t * pi + twistPhase) * 3 + strandOffset;
        final y = ropeTopY + (plankTop + 2 - ropeTopY) * t +
            sin(t * pi) * 6;
        ropePath.lineTo(x, y);
      }
      ropePaint
        ..color = Color.lerp(
          const Color(0xFF9B8060),
          const Color(0xFF6B5030),
          rng.nextDouble(),
        )!.withOpacity(0.5 + rng.nextDouble() * 0.4)
        ..strokeWidth = 2.5 - (strand - 2).abs() * 0.4;
      canvas.drawPath(ropePath, ropePaint);
    }

    // Frayed rope fibers at attachment points
    final fiberPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
    for (final attachX in [ropeTopLeftX, ropeTopRightX]) {
      for (int i = 0; i < 8; i++) {
        fiberPaint.color = const Color(0xFF9B8060).withOpacity(0.2 + rng.nextDouble() * 0.25);
        final fx = attachX + (rng.nextDouble() - 0.5) * 10;
        canvas.drawLine(
          Offset(fx, ropeTopY),
          Offset(fx + (rng.nextDouble() - 0.5) * 4, ropeTopY + 3 + rng.nextDouble() * 5),
          fiberPaint,
        );
      }
    }

    // — Draw wooden plank sign —
    final plankRect = Rect.fromLTWH(8, plankTop, w - 16, h - plankTop - 4);
    final plank = Path();
    const jag = 1.5;
    const step = 5.0;

    // Rough edges
    plank.moveTo(plankRect.left + 3, plankRect.top + rng.nextDouble() * jag);
    for (double x = plankRect.left + 3; x < plankRect.right - 3; x += step) {
      plank.lineTo(x, plankRect.top + rng.nextDouble() * jag);
    }
    for (double y = plankRect.top; y < plankRect.bottom; y += step) {
      plank.lineTo(plankRect.right - rng.nextDouble() * jag, y);
    }
    for (double x = plankRect.right; x > plankRect.left + 3; x -= step) {
      plank.lineTo(x, plankRect.bottom - rng.nextDouble() * jag);
    }
    for (double y = plankRect.bottom; y > plankRect.top; y -= step) {
      plank.lineTo(plankRect.left + rng.nextDouble() * jag, y);
    }
    plank.close();

    // Shadow
    canvas.drawPath(
      plank.shift(const Offset(2, 3)),
      Paint()..color = const Color(0xFF1A0A02).withOpacity(0.25),
    );

    // Wood fill
    canvas.save();
    canvas.clipPath(plank);
    canvas.drawRect(plankRect, Paint()..color = const Color(0xFFA07040));

    // Wood grain
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 15; i++) {
      final y = plankRect.top + rng.nextDouble() * plankRect.height;
      final path = Path()..moveTo(plankRect.left, y);
      for (double x = plankRect.left; x < plankRect.right; x += 8) {
        path.lineTo(x, y + (rng.nextDouble() - 0.5) * 2);
      }
      grainPaint
        ..color = rng.nextBool()
            ? const Color(0xFF5C3A1E).withOpacity(0.08 + rng.nextDouble() * 0.08)
            : const Color(0xFFC09560).withOpacity(0.06 + rng.nextDouble() * 0.08)
        ..strokeWidth = 0.4 + rng.nextDouble() * 1.0;
      canvas.drawPath(path, grainPaint);
    }

    // Bevel highlight top
    canvas.drawRect(
      Rect.fromLTWH(plankRect.left, plankRect.top, plankRect.width, plankRect.height * 0.35),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.12), Colors.transparent],
        ).createShader(plankRect),
    );
    // Shadow bottom
    canvas.drawRect(
      Rect.fromLTWH(plankRect.left, plankRect.bottom - plankRect.height * 0.25,
          plankRect.width, plankRect.height * 0.25),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.12)],
        ).createShader(plankRect),
    );

    canvas.restore();

    // Plank outline
    canvas.drawPath(
      plank,
      Paint()
        ..color = const Color(0xFF5C3A1E).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Rope holes on the plank (where rope threads through)
    for (final hx in [plankLeftRopeX, plankRightRopeX]) {
      canvas.drawCircle(
        Offset(hx, plankTop + 5),
        3,
        Paint()..color = const Color(0xFF2A1508).withOpacity(0.4),
      );
      canvas.drawCircle(
        Offset(hx - 0.5, plankTop + 4.5),
        1.2,
        Paint()..color = Colors.white.withOpacity(0.1),
      );
    }
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

    // Fold creases
    final creasePaint = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.10)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final creaseShadow = Paint()
      ..color = const Color(0xFF5C3317).withOpacity(0.05)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (final frac in [0.33, 0.5, 0.67]) {
      final y = size.height * frac;
      final p = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 6) {
        p.lineTo(x, y + rng.nextDouble() * 6 - 3);
      }
      canvas.drawPath(p.shift(const Offset(0, 1.5)), creaseShadow);
      canvas.drawPath(p, creasePaint);
    }
    for (final frac in [0.35, 0.5, 0.65]) {
      final x = size.width * frac;
      final p = Path()..moveTo(x, 0);
      for (double y = 0; y < size.height; y += 6) {
        p.lineTo(x + rng.nextDouble() * 5 - 2.5, y);
      }
      canvas.drawPath(p.shift(const Offset(1.5, 0)), creaseShadow);
      canvas.drawPath(p, creasePaint);
    }

    // Diagonal crumples
    for (int i = 0; i < 10; i++) {
      final x1 = rng.nextDouble() * size.width;
      final y1 = rng.nextDouble() * size.height;
      final len = 40 + rng.nextDouble() * size.width * 0.4;
      final angle = rng.nextDouble() * pi;
      final path = Path()..moveTo(x1, y1);
      path.quadraticBezierTo(
        x1 + cos(angle) * len * 0.5 + (rng.nextDouble() - 0.5) * 30,
        y1 + sin(angle) * len * 0.5 + (rng.nextDouble() - 0.5) * 30,
        x1 + cos(angle) * len,
        y1 + sin(angle) * len,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF8B7355).withOpacity(0.03 + rng.nextDouble() * 0.04)
          ..strokeWidth = 0.6 + rng.nextDouble() * 1.0
          ..style = PaintingStyle.stroke,
      );
    }

    // Tea stains
    for (int i = 0; i < 15; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
          width: (10 + rng.nextDouble() * 40) * (0.8 + rng.nextDouble() * 0.6),
          height: (10 + rng.nextDouble() * 40) * (0.5 + rng.nextDouble() * 0.5),
        ),
        Paint()
          ..color = Color.lerp(
            const Color(0xFF8B6914),
            const Color(0xFF6B4226),
            rng.nextDouble(),
          )!.withOpacity(0.02 + rng.nextDouble() * 0.03),
      );
    }

    // Paper grain
    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 250; i++) {
      grainPaint.color = const Color(0xFF8B7355).withOpacity(0.015 + rng.nextDouble() * 0.025);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.3 + rng.nextDouble() * 1.5,
        grainPaint,
      );
    }

    // Compass rose
    final cp = Paint()
      ..color = const Color(0xFF8B7355).withOpacity(0.07)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    final cc = Offset(size.width * 0.12, size.height * 0.9);
    const cr = 28.0;
    canvas.drawCircle(cc, cr, cp);
    canvas.drawCircle(cc, cr * 0.55, cp);
    for (final a in [0.0, pi / 2, pi, 3 * pi / 2]) {
      canvas.drawLine(
        cc + Offset(cos(a) * cr * 0.2, sin(a) * cr * 0.2),
        cc + Offset(cos(a) * (cr + 4), sin(a) * (cr + 4)),
        cp,
      );
    }
    for (final a in [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4]) {
      canvas.drawLine(
        cc + Offset(cos(a) * cr * 0.3, sin(a) * cr * 0.3),
        cc + Offset(cos(a) * cr * 0.8, sin(a) * cr * 0.8),
        cp..strokeWidth = 0.4,
      );
    }
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
            const Color(0xFF3E2010).withOpacity(0.25),
            const Color(0xFF2A1508).withOpacity(0.6),
          ],
          stops: const [0.0, 0.55, 0.8, 1.0],
        ).createShader(rect),
    );
    final scorchPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 15; i++) {
      final edge = rng.nextInt(4);
      double x, y;
      switch (edge) {
        case 0: x = rng.nextDouble() * size.width; y = rng.nextDouble() * 10; break;
        case 1: x = rng.nextDouble() * size.width; y = size.height - rng.nextDouble() * 10; break;
        case 2: x = rng.nextDouble() * 10; y = rng.nextDouble() * size.height; break;
        default: x = size.width - rng.nextDouble() * 10; y = rng.nextDouble() * size.height;
      }
      scorchPaint.color = const Color(0xFF1A0E05).withOpacity(0.08 + rng.nextDouble() * 0.1);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: 6 + rng.nextDouble() * 12,
          height: 3 + rng.nextDouble() * 8,
        ),
        scorchPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
