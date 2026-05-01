import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/illustrations.dart';

/// Primary teal button with 3D press depth
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
    this.gradient = const [Color(0xFF45F2B9), Color(0xFF2DE3AC)],
    this.shadowColor = const Color(0xFF00412F),
  });

  const GradientButton.quickPlay({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  })  : gradient = const [Color(0xFFFF7442), Color(0xFFFF5722)],
        shadowColor = const Color(0xFFAB3500);

  const GradientButton.create({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  })  : gradient = const [Color(0xFF7C3AED), Color(0xFF6C2BD9)],
        shadowColor = const Color(0xFF4A1B8F);

  const GradientButton.join({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  })  : gradient = const [Color(0xFF131A83), Color(0xFF0E1476)],
        shadowColor = const Color(0xFF000144);

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
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? 4.0 : 0.0),
        child: Opacity(
          opacity: widget.onPressed == null ? 0.4 : 1.0,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.gradient),
              borderRadius: BorderRadius.circular(24),
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
                  style: AppTheme.heading(size: 17, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary wood-textured button
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
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? 3.0 : 0.0),
        child: Opacity(
          opacity: widget.onPressed == null ? 0.4 : 1.0,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBright,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: AppTheme.outlineVariant.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: AppTheme.onSurface, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTheme.heading(size: 16, color: AppTheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Game card with surface-high background
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
        color: AppTheme.surfaceHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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

class ParchmentCard extends GameCard {
  const ParchmentCard({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    Color? color,
  }) : super(accentColor: null);
}

/// Section header with gold line
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
          Text(title, style: AppTheme.heading(size: 18)),
        ],
      ),
    );
  }
}
