import 'package:supabase_flutter/supabase_flutter.dart';

/// CRUD for feed posts, likes, and comments.
/// Expected Supabase table: posts(id, user_id, subject, body, image_urls, created_at)
class PostService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchFeed({String? subjectFilter, int limit = 20}) async {
    var query = _client.from('posts').select('*, users(name, avatar_url, is_verified)');
    if (subjectFilter != null && subjectFilter != 'બધા') {
      query = query.eq('subject', subjectFilter);
    }
    final res = await query.order('created_at', ascending: false).limit(limit);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> createPost({required String userId, required String subject, required String body, List<String> imageUrls = const []}) {
    return _client.from('posts').insert({
      'user_id': userId,
      'subject': subject,
      'body': body,
      'image_urls': imageUrls,
    });
  }

  Future<void> toggleLike({required String postId, required String userId}) async {
    final existing = await _client.from('likes').select().eq('post_id', postId).eq('user_id', userId).maybeSingle();
    if (existing == null) {
      await _client.from('likes').insert({'post_id': postId, 'user_id': userId});
    } else {
      await _client.from('likes').delete().eq('post_id', postId).eq('user_id', userId);
    }
  }
}
