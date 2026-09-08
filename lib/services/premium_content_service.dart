import 'package:supabase_flutter/supabase_flutter.dart';

/// Expected tables:
/// premium_content(id, creator_id, type[pdf/test/video], title, r2_key, price, created_at)
/// purchases(id, user_id, content_id, amount, gateway_fee, gst, created_at)
class PremiumContentService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchContent({String? type}) async {
    var query = _client.from('premium_content').select();
    if (type != null) query = query.eq('type', type);
    final res = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<bool> hasUnlocked({required String userId, required String contentId}) async {
    final res = await _client.from('purchases').select().eq('user_id', userId).eq('content_id', contentId).maybeSingle();
    return res != null;
  }

  /// Called after a successful Razorpay payment. Records the purchase;
  /// gateway fee + GST are deducted before crediting the creator payout
  /// ledger (handled server-side / via a Supabase Edge Function).
  Future<void> recordPurchase({required String userId, required String contentId, required num amount}) {
    return _client.from('purchases').insert({'user_id': userId, 'content_id': contentId, 'amount': amount});
  }

  /// Returns a short-lived signed URL for a Cloudflare R2 object so
  /// premium files are never publicly downloadable.
  Future<String> getSignedUrl(String r2Key) async {
    // TODO: call a Supabase Edge Function that signs the R2 object URL
    // (R2 supports S3-compatible presigned URLs).
    throw UnimplementedError('Wire this to your Edge Function that signs R2 URLs.');
  }
}
