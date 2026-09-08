import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'auth_gate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();

  bool _isSignUp = false;
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Valid email address નાખો');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password ઓછામાં ઓછું 6 characters નું હોવું જોઈએ');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isSignUp) {
        await _authService.signUp(
          email: email,
          password: password,
          name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
        );
      } else {
        await _authService.signIn(email: email, password: password);
      }
      if (!mounted) return;
      // AuthGate listens to onAuthStateChange, so a fresh session routes
      // straight to HomeShell automatically.
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
    } on AuthException catch (e) {
      setState(() => _error = _friendlyError(e.message));
    } on Object catch (e) {
      setState(() => _error = 'કંઈક ખોટું થયું. ફરી પ્રયત્ન કરો.');
      debugPrint('auth error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('invalid login credentials')) return 'Email અથવા password ખોટું છે.';
    if (lower.contains('user already registered')) return 'આ email થી પહેલેથી account છે — Login કરો.';
    if (lower.contains('email not confirmed')) return 'Email verify કરવા માટે inbox check કરો.';
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text.rich(
                const TextSpan(children: [
                  TextSpan(text: 'Study', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 26)),
                  TextSpan(text: 'Clips', style: TextStyle(color: AppColors.marigold, fontWeight: FontWeight.w800, fontSize: 26)),
                ]),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp ? 'નવું account બનાવો' : 'તમારા exam prep community માં join થાઓ',
                style: const TextStyle(color: AppColors.slate, fontSize: 13.5),
              ),
              const SizedBox(height: 32),

              if (_isSignUp) ...[
                _FieldLabel('નામ'),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration('તમારું નામ'),
                ),
                const SizedBox(height: 16),
              ],

              _FieldLabel('Email'),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('you@example.com'),
              ),
              const SizedBox(height: 16),

              _FieldLabel('Password'),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: _inputDecoration('••••••••').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.slateLight, size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              if (!_isSignUp)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        setState(() => _error = 'Reset link મોકલવા પહેલા email નાખો');
                        return;
                      }
                      await _authService.sendPasswordResetEmail(email);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset link email પર મોકલ્યો.')));
                      }
                    },
                    child: const Text('Password ભૂલી ગયા?', style: TextStyle(fontSize: 12.5, color: AppColors.slate)),
                  ),
                ),

              if (_error != null) ...[
                const SizedBox(height: 4),
                Text(_error!, style: const TextStyle(color: AppColors.coral, fontSize: 12.5)),
              ],

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isSignUp ? 'Sign Up' : 'Login'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => setState(() {
                    _isSignUp = !_isSignUp;
                    _error = null;
                  }),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 13, color: AppColors.slate),
                      children: [
                        TextSpan(text: _isSignUp ? 'પહેલેથી account છે? ' : 'Account નથી? '),
                        TextSpan(
                          text: _isSignUp ? 'Login કરો' : 'Sign Up કરો',
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F5EF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
      );
}
