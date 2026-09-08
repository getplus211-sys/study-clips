import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase email/password auth.
class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp({required String email, required String password, String? name}) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
  }

  Future<AuthResponse> signIn({required String email, required String password}) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signOut() => _client.auth.signOut();
}
