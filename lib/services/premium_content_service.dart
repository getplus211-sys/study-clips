import 'package:supabase_flutter/supabase_flutter.dart';
import 'storage_service.dart';

/// Expected tables (see sql/schema.sql):
/// premium_content(id, creator_id, type[pdf/test/video], title, storage_path, price, created_at)
/// purchases(id, user_id, content_id, amount, created_at)
class PremiumContentService {
  final _client = Supabase.instance.client;
  final _storage = StorageService();

  Future<List<Map<String, dynamic>>> fetchContent({String? type}) async {
    var query = _client.from('premium_content').select();
    if (type != null) query = query.eq('type', type);
    final res = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<bool> hasUnlocked({required String userId, required String contentId}) async {
    final res = await _client.from('purchases').select().eq('user_id', userId).eq('content_id', contentId).maybeSingle();
    return res != null;
  }

  /// Called after a successful Razorpay payment. Records the purchase.
  /// Gateway fee + GST are deducted before crediting the creator payout
  /// ledger — handled server-side via a Supabase Edge Function, not here.
  Future<void> recordPurchase({required String userId, required String contentId, required num amount}) {
    return _client.from('purchases').insert({'user_id': userId, 'content_id': contentId, 'amount': amount});
  }

  /// Returns a short-lived signed URL for a premium file so it's never
  /// publicly downloadable without an unlocked purchase.
  Future<String> getSignedUrl(String storagePath) {
    return _storage.getSignedUrl(storagePath);
  }
}
