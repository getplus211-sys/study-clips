import 'package:supabase_flutter/supabase_flutter.dart';

/// Expected tables:
/// discussions(id, user_id, subject, title, solved, created_at)
/// discussion_replies(id, discussion_id, user_id, body, created_at)
class DiscussService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchQuestions({int limit = 20}) async {
    final res = await _client
        .from('discussions')
        .select('*, users(name, is_verified), discussion_replies(count)')
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> askQuestion({required String userId, required String subject, required String title}) {
    return _client.from('discussions').insert({'user_id': userId, 'subject': subject, 'title': title, 'solved': false});
  }

  Future<void> reply({required String discussionId, required String userId, required String body}) {
    return _client.from('discussion_replies').insert({'discussion_id': discussionId, 'user_id': userId, 'body': body});
  }
}
