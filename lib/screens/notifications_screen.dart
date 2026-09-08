import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        children: const [
          _SectionLabel('TODAY'),
          NotificationTile(
            icon: Icons.favorite, iconBg: Color(0xFFFDEDED), iconColor: AppColors.coral,
            text: 'Kiran Rathod એ તમારી post ને like કરી', time: '20 મિનિટ પહેલા', read: false,
          ),
          NotificationTile(
            icon: Icons.workspace_premium, iconBg: Color(0xFFFFF3DC), iconColor: AppColors.marigoldDeep,
            text: 'નવો Mock Test — GPSC Prelims #13 હવે available છે', time: '1 કલાક પહેલા', read: false,
          ),
          _SectionLabel('EARLIER'),
          NotificationTile(
            icon: Icons.forum, iconBg: Color(0xFFEAF3FF), iconColor: Color(0xFF2563EB),
            text: 'Nikita Joshi એ તમારા doubt નો જવાબ આપ્યો', time: 'ગઇકાલે', read: true,
          ),
          NotificationTile(
            icon: Icons.check_circle, iconBg: Color(0xFFE8F5EC), iconColor: AppColors.green,
            text: 'તમારું Premium Pass સફળતાપૂર્વક activate થયું', time: '2 દિવસ પહેલા', read: true,
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
        child: Text(text, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.slateLight)),
      );
}
