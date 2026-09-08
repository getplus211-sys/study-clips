import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_tile.dart';
import 'chat_room_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        children: [
          const _SectionLabel('GROUPS'),
          ChatTile(
            name: 'PSI Batch 2026', initials: 'PSI', isGroup: true, isVerified: true,
            lastMessage: 'Meera: કાલે mock test ૯ વાગે', time: '10:42', unreadCount: 5,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatRoomScreen(title: 'PSI Batch 2026'))),
          ),
          ChatTile(
            name: 'Daily GK Group', initials: 'GK', isGroup: true,
            lastMessage: "Today's current affairs PDF", time: '09:15',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatRoomScreen(title: 'Daily GK Group'))),
          ),
          const Divider(height: 1),
          const _SectionLabel('DIRECT MESSAGES'),
          ChatTile(
            name: 'Dipika Vora', initials: 'દી',
            lastMessage: 'Thanks! notes મળી ગયા', time: 'Yesterday',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatRoomScreen(title: 'Dipika Vora'))),
          ),
          ChatTile(
            name: 'Rohan Vaghela', initials: 'રો',
            lastMessage: 'Mock test ma 78 score aavyo', time: 'Mon', unreadCount: 1,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatRoomScreen(title: 'Rohan Vaghela'))),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: Text(text, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.slateLight)),
      );
}
