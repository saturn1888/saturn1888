import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern adventure palette
  static const Color gold = Color(0xFFD4A04A);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color warmBrown = Color(0xFF4A3228);
  static const Color leather = Color(0xFF7D5A3C);
  static const Color parchment = Color(0xFFF7F1E8);
  static const Color cream = Color(0xFFF7F1E8);
  static const Color adventureGreen = Color(0xFF2E7D5A);
  static const Color rust = Color(0xFFA0522D);
  static const Color inkBrown = Color(0xFF2C1810);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color subtleGrey = Color(0xFF8A8A8A);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        brightness: Brightness.light,
        primary: darkGold,
        secondary: adventureGreen,
        surface: parchment,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: warmBrown,
        foregroundColor: const Color(0xFFF5EDD8),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: const Color(0xFFF5EDD8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          textStyle: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.15),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkGold, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        selectedColor: darkGold,
        backgroundColor: const Color(0xFFF0EBE3),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
    );
  }

  // Text hierarchy
  static TextStyle heading({double size = 28, Color? color}) {
    return GoogleFonts.fredoka(
      fontWeight: FontWeight.w700,
      fontSize: size,
      color: color ?? warmBrown,
    );
  }

  static TextStyle body({double size = 16, Color? color}) {
    return GoogleFonts.nunito(
      fontSize: size,
      color: color ?? inkBrown,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle caption({double size = 12, Color? color}) {
    return GoogleFonts.nunito(
      fontSize: size,
      color: color ?? subtleGrey,
      fontWeight: FontWeight.w500,
    );
  }
}
