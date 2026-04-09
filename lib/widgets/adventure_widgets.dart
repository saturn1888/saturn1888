import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/illustrations.dart';

/// Gradient action button with shadow depth effect
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final List<Color> gradient;
  final Color shadowColor;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = const [Color(0xFF06D6A0), Color(0xFF009E78)],
    this.shadowColor = const Color(0xFF007A5C),
  });

  // Named constructors for common styles
  const GradientButton.quickPlay({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  })  : gradient = const [Color(0xFFFF6B35), Color(0xFFFF8C42)],
        shadowColor = const Color(0xB3B43C00);

  const GradientButton.create({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  })  : gradient = const [Color(0xFF7C3AED), Color(0xFF9B59D4)],
        shadowColor = const Color(0x99501496);

  const GradientButton.join({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  })  : gradient = const [Color(0xFF2E3590), Color(0xFF3A42AA)],
        shadowColor = const Color(0xCC0A0F3C);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? 4.0 : 0.0)
          ..scale(_pressed ? 0.97 : 1.0),
        child: Opacity(
          opacity: widget.onPressed == null ? 0.4 : 1.0,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!_pressed)
                  BoxShadow(
                    color: widget.shadowColor,
                    blurRadius: 0,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTheme.heading(size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wood textured button (kept for secondary actions)
class WoodButton extends StatefulWidget {
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
  State<WoodButton> createState() => _WoodButtonState();
}

class _WoodButtonState extends State<WoodButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? 3.0 : 0.0)
          ..scale(_pressed ? 0.97 : 1.0),
        child: Opacity(
          opacity: widget.onPressed == null ? 0.4 : 1.0,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage(Illustrations.woodPlank),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                if (!_pressed)
                  BoxShadow(
                    color: const Color(0xFF5C3A1E).withOpacity(0.6),
                    blurRadius: 0,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: AppTheme.gold, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTheme.heading(size: 17, color: AppTheme.gold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A card with navy gradient background, border, and shadow
class GameCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? accentColor;

  const GameCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3590), Color(0xFF252B7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            if (accentColor != null)
              Container(width: 4, color: accentColor),
            Expanded(
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legacy aliases for compatibility
class ParchmentCard extends GameCard {
  const ParchmentCard({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    Color? color,
  }) : super(accentColor: null);
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
                    AppTheme.gold.withOpacity(0.5),
                    AppTheme.gold.withOpacity(0.0),
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
