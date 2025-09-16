// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'screens/tic_tac_toe_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    // ignore: prefer_const_declarations
    final scheme = const ColorScheme.dark(
      primary: Color(0xFF00E5FF),
      secondary: Color(0xFFFF2DD5),
      tertiary: Color(0xFF7A3BFF),
      surface: Color(0xFF101428),
      background: Color(0xFF0C0D21),
    );
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: base.copyWith(
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFF0C0D21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        splashFactory: InkSparkle.splashFactory,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1B1F3E),
          contentTextStyle: base.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const TicTacToeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
