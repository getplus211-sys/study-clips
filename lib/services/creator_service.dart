import 'package:supabase_flutter/supabase_flutter.dart';

/// Expected tables:
/// creators(user_id, is_active, fee_expires_at)
/// creator_subscriptions(id, user_id, amount, paid_at, valid_until)
class CreatorService {
  final _client = Supabase.instance.client;

  Future<bool> isActiveCreator(String userId) async {
    final res = await _client.from('creators').select('is_active, fee_expires_at').eq('user_id', userId).maybeSingle();
    if (res == null) return false;
    final expiresAt = DateTime.tryParse(res['fee_expires_at'] ?? '');
    return (res['is_active'] == true) && (expiresAt != null && expiresAt.isAfter(DateTime.now()));
  }

  /// Called after a successful Razorpay payment for the fixed creator fee.
  Future<void> activateCreator({required String userId, required num amount}) async {
    final validUntil = DateTime.now().add(const Duration(days: 30));
    await _client.from('creator_subscriptions').insert({'user_id': userId, 'amount': amount, 'valid_until': validUntil.toIso8601String()});
    await _client.from('creators').upsert({'user_id': userId, 'is_active': true, 'fee_expires_at': validUntil.toIso8601String()});
  }

  Future<void> uploadContent({
    required String creatorId,
    required String type,
    required String title,
    required String r2Key,
    required num price,
  }) {
    return _client.from('premium_content').insert({
      'creator_id': creatorId,
      'type': type,
      'title': title,
      'r2_key': r2Key,
      'price': price,
    });
  }
}
