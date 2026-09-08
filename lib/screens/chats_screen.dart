import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_tile.dart';
import '../widgets/async_state_view.dart';
import '../services/chat_service.dart';
import 'chat_room_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _chatService = ChatService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    _future = userId != null ? _chatService.fetchChats(userId) : Future.value(const []);
  }

  void _reload() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    setState(() => _future = userId != null ? _chatService.fetchChats(userId) : Future.value(const []));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: AsyncStateView<List<Map<String, dynamic>>>(
          future: _future,
          isEmpty: (rows) => rows.isEmpty,
          emptyMessage: 'હજુ કોઈ chat નથી — કોઈ group join કરો.',
          onRetry: _reload,
          builder: (context, rows) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final chat = rows[i]['chats'] as Map<String, dynamic>? ?? {};
                final isGroup = (chat['is_group'] as bool?) ?? false;
                final name = (chat['name'] as String?) ?? 'Chat';
                final messages = chat['chat_messages'] as List? ?? const [];
                final lastMsg = messages.isNotEmpty ? (messages.last['text'] as String? ?? '') : '';
                final chatId = chat['id'] as String?;
                return ChatTile(
                  name: name,
                  initials: name.isNotEmpty ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase() : '?',
                  isGroup: isGroup,
                  lastMessage: lastMsg,
                  time: '',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomScreen(title: name, chatId: chatId))),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
