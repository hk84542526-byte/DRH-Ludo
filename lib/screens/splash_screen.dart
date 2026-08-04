import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events,
                  color: AppTheme.gold, size: 60),
              const SizedBox(height: 8),
              const DrhLogo(size: 44),
              const SizedBox(height: 16),
              const Text(
                '★ खेलो और बनो LUDO चैंपियन! ★',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: AppTheme.gold,
                    strokeWidth: 3,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
