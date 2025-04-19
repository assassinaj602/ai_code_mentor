import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/1048/1048953.png',
              height: 100,
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.5, end: 0, duration: 800.ms),
            const SizedBox(height: 24),
            Text(
              'ShoeShop',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
            const SizedBox(height: 12),
            Text(
              'Step up your style',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
