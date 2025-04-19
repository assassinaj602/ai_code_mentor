import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
    error: AppColors.danger,
  ),
  fontFamily: GoogleFonts.poppins().fontFamily,
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    displayLarge: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
    displayMedium: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
    displaySmall: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
    titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
    labelLarge: TextStyle(fontWeight: FontWeight.w600),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    ),
    iconTheme: IconThemeData(color: Colors.black87),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    elevation: 4,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey.shade600,
    showUnselectedLabels: true,
    elevation: 4,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);

final ThemeData darkAppTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: const Color(0xFF181A20),
  colorScheme: ColorScheme.dark(
    primary: Colors.indigo,
    secondary: Colors.amber,
    background: const Color(0xFF181A20),
    surface: const Color(0xFF23243A),
  ),
  fontFamily: GoogleFonts.poppins().fontFamily,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
    displayLarge: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
    displayMedium: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    displaySmall: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white54),
    labelLarge: TextStyle(fontWeight: FontWeight.w600),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: const Color(0xFF23243A),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.indigo,
    elevation: 4,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF23243A),
    selectedItemColor: Colors.indigo,
    unselectedItemColor: Colors.grey.shade400,
    showUnselectedLabels: true,
    elevation: 4,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
    filled: true,
    fillColor: const Color(0xFF2C2F3A),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);

// Custom color palette
class AppColors {
  static Color primary = Color(0xFF6C63FF);
  static Color secondary = Color(0xFF4FC3F7);
  static Color success = Color(0xFF4CAF50);
  static Color warning = Color(0xFFFF9800);
  static Color danger = Color(0xFFF44336);
  static Color background = Color(0xFFF8F9FA);
}
