import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFF0EA5E9)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.build_rounded, size: 64, color: Colors.white),
              ),
              const SizedBox(height: 28),
              const Text('شطبلي', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text('الصنايعي في جيبك 🛠️', style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.85))),
            ],
          ),
        ),
      ),
    );
  }
}
