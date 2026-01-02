import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cyber Dark Palette
  static const Color _darkBackground = Color(0xFF030712); // Deepest Navy/Black
  static const Color _darkSurface = Color(0xFF0F172A); // Dark Slate
  static const Color _darkPrimary = Color(0xFF818CF8); // Indigo
  static const Color _darkSecondary = Color(0xFFC084FC); // Purple
  static const Color _darkTertiary = Color(0xFF2DD4BF); // Teal
  static const Color _darkError = Color(0xFFF43F5E); // Rose

  // Clean Light Palette
  static const Color _lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color _lightSurface = Color(0xFFFFFFFF); // White
  static const Color _lightPrimary = Color(0xFF4F46E5); // Indigo 600
  static const Color _lightSecondary = Color(0xFF9333EA); // Purple 600
  static const Color _lightTertiary = Color(0xFF0D9488); // Teal 600
  static const Color _lightError = Color(0xFFDC2626); // Red 600

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _darkPrimary,
        onPrimary: Colors.white,
        secondary: _darkSecondary,
        onSecondary: Colors.white,
        tertiary: _darkTertiary,
        onTertiary: Colors.black,
        error: _darkError,
        onError: Colors.white,
        surface: _darkBackground,
        onSurface: Color(0xFFE2E8F0), // Slate 200
        surfaceContainer: _darkSurface,
        onSurfaceVariant: Color(0xFF94A3B8), // Slate 400
        outline: Color(0xFF334155), // Slate 700
      ),
      scaffoldBackgroundColor: _darkBackground,
      cardTheme: CardTheme(
        color: _darkSurface.withOpacity(0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme, true),
      iconTheme: const IconThemeData(color: Colors.white),
      dividerColor: const Color(0xFF1E293B),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _lightPrimary,
        onPrimary: Colors.white,
        secondary: _lightSecondary,
        onSecondary: Colors.white,
        tertiary: _lightTertiary,
        onTertiary: Colors.white,
        error: _lightError,
        onError: Colors.white,
        surface: _lightBackground,
        onSurface: Color(0xFF0F172A), // Slate 900
        surfaceContainer: _lightSurface,
        onSurfaceVariant: Color(0xFF64748B), // Slate 500
        outline: Color(0xFFE2E8F0), // Slate 200
      ),
      scaffoldBackgroundColor: _lightBackground,
      cardTheme: CardTheme(
        color: _lightSurface,
        elevation: 10,
        shadowColor: const Color(0xFF64748B).withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.black.withOpacity(0.02)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme, false),
      iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      dividerColor: const Color(0xFFE2E8F0),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, bool isDark) {
    final textColor =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final mutedColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return GoogleFonts.plusJakartaSansTextTheme(base).copyWith(
      displayLarge: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 57,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 45,
        letterSpacing: -0.25,
      ),
      displaySmall: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 36,
        letterSpacing: -0.25,
      ),
      headlineLarge: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 28,
      ),
      headlineSmall: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(color: textColor, fontSize: 16),
      bodyMedium: GoogleFonts.plusJakartaSans(color: mutedColor, fontSize: 14),
      bodySmall: GoogleFonts.plusJakartaSans(color: mutedColor, fontSize: 12),
      labelLarge: GoogleFonts.plusJakartaSans(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }
}
