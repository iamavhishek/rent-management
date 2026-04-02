import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Nepal-inspired color palette
  static const Color primary = Color(0xFF1A237E); // Deep Indigo
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color accent = Color(0xFF00897B); // Teal
  static const Color accentLight = Color(0xFF4DB6AC);
  static const Color surface = Color(0xFFF8F9FD);
  static const Color cardColor = Colors.white;
  static const Color danger = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color success = Color(0xFF43A047);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color divider = Color(0xFFE5E7EB);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    scaffoldBackgroundColor: surface,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 15, color: textPrimary),
      bodyMedium: GoogleFonts.inter(fontSize: 13, color: textSecondary),
      bodySmall: GoogleFonts.inter(fontSize: 11, color: textSecondary),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      foregroundColor: textPrimary,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: divider, width: 1),
      ),
      color: cardColor,
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: danger, width: 1),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
      labelStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
      isDense: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: Colors.grey.shade300),
        textStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
    ),
    dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(color: Colors.grey.shade300),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: textPrimary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLight,
      brightness: Brightness.dark,
      primary: primaryLight,
      secondary: accentLight,
      surface: const Color(0xFF121212),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: const Color(0xFF121212),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryLight, width: 1.5),
      ),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      isDense: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey.shade800, thickness: 1),
  );
}
