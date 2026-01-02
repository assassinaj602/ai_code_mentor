import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/analysis/providers/analysis_provider.dart';
import 'features/analysis/screens/home_screen.dart';
import 'features/analysis/screens/splash_screen.dart';
import 'features/analysis/screens/history_screen.dart';
import 'features/analysis/screens/settings_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/providers/auth_provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Ai Code Mentor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          themeMode == 'dark'
              ? ThemeMode.dark
              : themeMode == 'light'
              ? ThemeMode.light
              : ThemeMode.system,
      home:
          authState.isLoading
              ? const SplashScreen() // Or a loading scaffold
              : authState.user == null
              ? const LoginScreen()
              : const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
