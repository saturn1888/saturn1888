import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/illustrations.dart';

/// Primary action button with wood plank texture background
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
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.4 : 1.0,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            image: DecorationImage(
              image: const AssetImage(Illustrations.woodPlank),
              fit: BoxFit.cover,
              onError: (_, __) {},
            ),
            boxShadow: [
              BoxShadow(
                color: (color ?? const Color(0xFF6B4A2E)).withOpacity(0.4),
                blurRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: (color ?? const Color(0xFF8B6B40)).withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppTheme.gold, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTheme.heading(size: 18, color: AppTheme.gold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A card with navy background and subtle border
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
        color: color ?? AppTheme.navyLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
