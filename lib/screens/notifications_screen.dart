import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/notification_tile.dart';
import '../widgets/async_state_view.dart';
import '../services/notifications_data_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = NotificationsDataService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    _future = userId != null ? _service.fetchNotifications(userId) : Future.value(const []);
  }

  void _reload() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    setState(() => _future = userId != null ? _service.fetchNotifications(userId) : Future.value(const []));
  }

  IconData _iconFor(String? key) {
    switch (key) {
      case 'like': return Icons.favorite;
      case 'reply': return Icons.forum;
      case 'purchase': return Icons.check_circle;
      case 'content': return Icons.workspace_premium;
      default: return Icons.notifications;
    }
  }

  Color _bgFor(String? key) {
    switch (key) {
      case 'like': return const Color(0xFFFDEDED);
      case 'reply': return const Color(0xFFEAF3FF);
      case 'purchase': return const Color(0xFFE8F5EC);
      case 'content': return const Color(0xFFFFF3DC);
      default: return const Color(0xFFF2F0EA);
    }
  }

  Color _colorFor(String? key) {
    switch (key) {
      case 'like': return AppColors.coral;
      case 'reply': return const Color(0xFF2563EB);
      case 'purchase': return AppColors.green;
      case 'content': return AppColors.marigoldDeep;
      default: return AppColors.slate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: AsyncStateView<List<Map<String, dynamic>>>(
          future: _future,
          isEmpty: (rows) => rows.isEmpty,
          emptyMessage: 'હજુ કોઈ notification નથી.',
          onRetry: _reload,
          builder: (context, rows) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final row = rows[i];
                return NotificationTile(
                  icon: _iconFor(row['icon'] as String?),
                  iconBg: _bgFor(row['icon'] as String?),
                  iconColor: _colorFor(row['icon'] as String?),
                  text: (row['text'] as String?) ?? '',
                  time: (row['created_at'] as String?) ?? '',
                  read: (row['read'] as bool?) ?? false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
