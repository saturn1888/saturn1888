import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Rich treasure palette
  static const Color gold = Color(0xFFE8A817);        // Warm antique gold
  static const Color darkGold = Color(0xFFC7880B);     // Deep treasure gold
  static const Color warmBrown = Color(0xFF5C3317);    // Rich dark wood
  static const Color leather = Color(0xFF8B5E3C);      // Leather brown
  static const Color parchment = Color(0xFFF2E6D0);    // Warm parchment
  static const Color cream = Color(0xFFF2E6D0);        // Same as parchment (compat)
  static const Color adventureGreen = Color(0xFF1B6B3A); // Deep forest green
  static const Color rust = Color(0xFFA0522D);         // Rusty accent
  static const Color inkBrown = Color(0xFF3E2723);     // Dark ink

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
      scaffoldBackgroundColor: Colors.transparent, // Let ParchmentBackground show through
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF4A2810),
        foregroundColor: const Color(0xFFF5DEB3),
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.brown.withOpacity(0.5),
        titleTextStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: const Color(0xFFF5DEB3),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 56),
          textStyle: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 4,
          shadowColor: Colors.brown.withOpacity(0.4),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: Colors.brown.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: leather.withOpacity(0.15)),
        ),
        color: const Color(0xFFF5EDE0),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: warmBrown,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFAF5ED),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: leather.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: leather.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkGold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        selectedColor: darkGold,
        backgroundColor: const Color(0xFFEDE0D0),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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
}
