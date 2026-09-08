import 'package:supabase_flutter/supabase_flutter.dart';

/// Expected table: notifications(id, user_id, icon, text, read, created_at)
/// Populated by database triggers / Edge Functions when a like, reply,
/// or purchase happens (not written to directly from the client, other
/// than marking as read).
class NotificationsService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchNotifications(String userId, {int limit = 30}) async {
    final res = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<void> markRead(String notificationId) {
    return _client.from('notifications').update({'read': true}).eq('id', notificationId);
  }
}
