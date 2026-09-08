import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGate()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.ink,
      body: Center(
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: 'Study', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: -0.5)),
            TextSpan(text: 'Clips', style: TextStyle(color: AppColors.marigold, fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: -0.5)),
          ]),
        ),
      ),
    );
  }
}
