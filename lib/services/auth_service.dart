import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase phone/OTP auth. Hook this up once your Supabase
/// project has phone auth (or email/password) enabled.
class AuthService {
  final _client = Supabase.instance.client;

  Future<void> sendOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  Future<AuthResponse> verifyOtp(String phone, String token) {
    return _client.auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
  }

  User? get currentUser => _client.auth.currentUser;

  Future<void> signOut() => _client.auth.signOut();
}
