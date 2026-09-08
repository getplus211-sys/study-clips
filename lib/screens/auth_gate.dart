import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'home_shell.dart';

/// Listens to Supabase's auth state stream and routes accordingly.
/// This replaces navigating to HomeShell unconditionally from LoginScreen —
/// session persistence (supabase_flutter persists sessions to disk by
/// default) now actually determines what the user sees on relaunch.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return const HomeShell();
        }
        return const LoginScreen();
      },
    );
  }
}
