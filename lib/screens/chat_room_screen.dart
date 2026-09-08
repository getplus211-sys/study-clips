import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatRoomScreen extends StatefulWidget {
  final String title;
  const ChatRoomScreen({super.key, required this.title});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _controller = TextEditingController();

  // TODO: wire to ChatService (Supabase Realtime channel) for live messages.
  final _messages = const [
    ('Meera', 'કાલે mock test ૯ વાગે start થશે', false),
    ('You', 'Ok, ready chhu 👍', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final (sender, text, mine) = _messages[i];
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
                    child: Text(text, style: TextStyle(color: mine ? Colors.white : const Color(0xFF2A2A2A), fontSize: 14)),
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
                    child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: () {
                      // TODO: ChatService.sendMessage(...)
                      _controller.clear();
                    }),
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
