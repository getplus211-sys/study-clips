import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Storage wrapper. Two buckets are used (see AppConfig):
///  - `media`           — public bucket for post images / avatars
///  - `premium-content` — private bucket for PDFs / mock-test assets;
///                        served only via short-lived signed URLs.
///
/// NOTE: earlier planning had this on Cloudflare R2 for lower egress
/// cost. Per your latest instruction this now uses Supabase Storage;
/// R2 migration is deferred (see sql/schema.sql comment + README).
class StorageService {
  final _client = Supabase.instance.client;

  Future<String> uploadPublicMedia({required String path, required Uint8List bytes, required String contentType}) async {
    await _client.storage.from('media').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: contentType, upsert: true));
    return _client.storage.from('media').getPublicUrl(path);
  }

  Future<void> uploadPremiumFile({required String path, required Uint8List bytes, required String contentType}) {
    return _client.storage.from('premium-content').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: contentType, upsert: true));
  }

  /// Signed URL valid for [expiresInSeconds] — default 10 minutes.
  /// Call this right before showing/downloading a premium file; do not
  /// cache long-term since the URL expires.
  Future<String> getSignedUrl(String path, {int expiresInSeconds = 600}) {
    return _client.storage.from('premium-content').createSignedUrl(path, expiresInSeconds);
  }
}
