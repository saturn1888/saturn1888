import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Celestial Quest palette
  static const Color background = Color(0xFF000144);
  static const Color surface = Color(0xFF04085E);
  static const Color surfaceHigh = Color(0xFF080E6A);
  static const Color surfaceBright = Color(0xFF131A83);
  static const Color surfaceVariant = Color(0xFF0E1476);
  static const Color primary = Color(0xFF45F2B9);
  static const Color primaryDim = Color(0xFF2DE3AC);
  static const Color secondary = Color(0xFFFF7442);
  static const Color secondaryContainer = Color(0xFFAB3500);
  static const Color tertiary = Color(0xFFFFDD7A);
  static const Color onSurface = Color(0xFFE3E3FF);
  static const Color onSurfaceVariant = Color(0xFFA0A6EC);
  static const Color outline = Color(0xFF6A70B2);
  static const Color outlineVariant = Color(0xFF3D4281);
  static const Color error = Color(0xFFFF716C);

  // Legacy aliases
  static const Color navy = background;
  static const Color navyLight = surfaceHigh;
  static const Color teal = primary;
  static const Color orange = secondary;
  static const Color gold = tertiary;
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color textLight = onSurface;
  static const Color textMuted = onSurfaceVariant;
  static const Color darkGold = tertiary;
  static const Color warmBrown = background;
  static const Color leather = surfaceHigh;
  static const Color parchment = background;
  static const Color cream = background;
  static const Color adventureGreen = primary;
  static const Color rust = secondary;
  static const Color inkBrown = onSurface;
  static const Color subtleGrey = onSurfaceVariant;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        onPrimary: const Color(0xFF00563E),
        onSecondary: const Color(0xFF410F00),
        onSurface: onSurface,
        error: error,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredokaOne(
          fontSize: 20,
          color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 56),
          textStyle: GoogleFonts.fredokaOne(fontSize: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: const Color(0xFF00563E),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: BorderSide(color: outlineVariant.withOpacity(0.15)),
          foregroundColor: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: surfaceHigh,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: const Color(0xFF00563E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF000000), // surface-container-lowest
        hintStyle: TextStyle(color: onSurfaceVariant.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outlineVariant.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outlineVariant.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        selectedColor: tertiary,
        backgroundColor: surfaceVariant,
        labelStyle: TextStyle(fontWeight: FontWeight.w800, color: onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: BorderSide.none,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: outlineVariant.withOpacity(0.15),
        thickness: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.fredokaOne(
          fontSize: 22,
          color: onSurface,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primary : onSurfaceVariant),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? primary.withOpacity(0.3)
                : outlineVariant.withOpacity(0.15)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // Text hierarchy — Fredoka One for headings
  static TextStyle heading({double size = 28, Color? color}) {
    return GoogleFonts.fredokaOne(
      fontSize: size,
      color: color ?? onSurface,
    );
  }

  // Plus Jakarta Sans for body (falling back to Nunito)
  static TextStyle body({double size = 16, Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? onSurface,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle caption({double size = 12, Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );
  }
}
