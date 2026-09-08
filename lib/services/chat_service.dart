import 'package:supabase_flutter/supabase_flutter.dart';

/// Expected tables:
/// chats(id, is_group, name, created_at)
/// chat_participants(chat_id, user_id)
/// chat_messages(id, chat_id, user_id, text, created_at)
class ChatService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchChats(String userId) async {
    final res = await _client
        .from('chat_participants')
        .select('chats(id, is_group, name, chat_messages(text, created_at))')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(res);
  }

  /// Subscribe to live messages for a chat room.
  RealtimeChannel subscribeToMessages(String chatId, void Function(Map<String, dynamic>) onMessage) {
    return _client
        .channel('chat:$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'chat_id', value: chatId),
          callback: (payload) => onMessage(payload.newRecord),
        )
        .subscribe();
  }

  Future<void> sendMessage({required String chatId, required String userId, required String text}) {
    return _client.from('chat_messages').insert({'chat_id': chatId, 'user_id': userId, 'text': text});
  }
}
