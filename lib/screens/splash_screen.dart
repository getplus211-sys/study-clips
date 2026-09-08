import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: check AuthService session; route to HomeShell if already logged in.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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
