import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../services/chat_service.dart';

class ChatRoomScreen extends StatefulWidget {
  final String title;
  final String? chatId; // null while chat creation/lookup isn't wired from ChatsScreen yet
  const ChatRoomScreen({super.key, required this.title, this.chatId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _controller = TextEditingController();
  final _chatService = ChatService();
  final List<Map<String, dynamic>> _messages = [];
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    if (widget.chatId != null) {
      _channel = _chatService.subscribeToMessages(widget.chatId!, (msg) {
        setState(() => _messages.add(msg));
      });
    }
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (text.isEmpty || userId == null || widget.chatId == null) return;
    _controller.clear();
    try {
      await _chatService.sendMessage(chatId: widget.chatId!, userId: userId, text: text);
      // The realtime subscription above will append it once the insert
      // event round-trips — no need to add it locally here.
    } on Object catch (e) {
      debugPrint('sendMessage error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message મોકલવામાં તકલીફ થઈ.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myId = Supabase.instance.client.auth.currentUser?.id;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('હજુ કોઈ message નથી.', style: TextStyle(color: AppColors.slateLight, fontSize: 13.5)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final msg = _messages[i];
                      final mine = msg['user_id'] == myId;
                      return Align(
                        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                          decoration: BoxDecoration(
                            color: mine ? AppColors.ink : const Color(0xFFF2F0EA),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            (msg['text'] as String?) ?? '',
                            style: TextStyle(color: mine ? Colors.white : const Color(0xFF2A2A2A), fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Message લખો...',
                        filled: true,
                        fillColor: const Color(0xFFF2F0EA),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.ink,
                    child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: _send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
