import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Midnight navy palette
  static const Color navy = Color(0xFF1A1F5E);
  static const Color navyLight = Color(0xFF2E3590);
  static const Color teal = Color(0xFF06D6A0);
  static const Color orange = Color(0xFFFF6B35);
  static const Color gold = Color(0xFFFFD23F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color textLight = Color(0xFFE8E8F0);
  static const Color textMuted = Color(0xFF9A9AB0);

  // Legacy names for compatibility
  static const Color darkGold = Color(0xFFFFD23F);
  static const Color warmBrown = Color(0xFF1A1F5E);
  static const Color leather = Color(0xFF2E3590);
  static const Color parchment = Color(0xFF1A1F5E);
  static const Color cream = Color(0xFF1A1F5E);
  static const Color adventureGreen = Color(0xFF06D6A0);
  static const Color rust = Color(0xFFFF6B35);
  static const Color inkBrown = Color(0xFFE8E8F0);
  static const Color surface = Color(0xFF2E3590);
  static const Color subtleGrey = Color(0xFF9A9AB0);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: teal,
        secondary: orange,
        surface: navyLight,
        onPrimary: navy,
        onSecondary: white,
        onSurface: textLight,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: navy.withOpacity(0.95),
        foregroundColor: textLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: textLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          textStyle: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          backgroundColor: teal,
          foregroundColor: navy,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: BorderSide(color: white.withOpacity(0.15)),
          foregroundColor: textLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: white.withOpacity(0.1)),
        ),
        color: navyLight,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: navy,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: navy,
        hintStyle: TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        selectedColor: teal,
        backgroundColor: navyLight,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, color: textLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: white.withOpacity(0.1)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: navyLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: white.withOpacity(0.1),
        thickness: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: navyLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textLight,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: teal),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? teal : textMuted),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? teal.withOpacity(0.3)
                : white.withOpacity(0.1)),
      ),
    );
  }

  // Text hierarchy
  static TextStyle heading({double size = 28, Color? color}) {
    return GoogleFonts.fredoka(
      fontWeight: FontWeight.w700,
      fontSize: size,
      color: color ?? textLight,
    );
  }

  static TextStyle body({double size = 16, Color? color}) {
    return GoogleFonts.nunito(
      fontSize: size,
      color: color ?? textLight,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle caption({double size = 12, Color? color}) {
    return GoogleFonts.nunito(
      fontSize: size,
      color: color ?? textMuted,
      fontWeight: FontWeight.w600,
    );
  }
}
