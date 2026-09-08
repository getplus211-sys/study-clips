import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                const TextSpan(children: [
                  TextSpan(text: 'Study', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 26)),
                  TextSpan(text: 'Clips', style: TextStyle(color: AppColors.marigold, fontWeight: FontWeight.w800, fontSize: 26)),
                ]),
              ),
              const SizedBox(height: 8),
              const Text('તમારા exam prep community માં join થાઓ', style: TextStyle(color: AppColors.slate, fontSize: 13.5)),
              const SizedBox(height: 36),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'મોબાઈલ નંબર',
                  filled: true,
                  fillColor: const Color(0xFFF7F5EF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: AuthService.sendOtp(_phoneController.text)
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
                  },
                  child: const Text('OTP મોકલો'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
