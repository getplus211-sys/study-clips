import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';
import 'verified_badge.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isGroup;
  final bool isVerified;
  final String initials;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.initials,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isVerified = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            isGroup
                ? Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(14)),
                    alignment: Alignment.center,
                    child: Text(initials, style: const TextStyle(color: AppColors.marigold, fontWeight: FontWeight.w800, fontSize: 13)),
                  )
                : UserAvatar(initials: initials, radius: 22, isVerified: isVerified),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink), overflow: TextOverflow.ellipsis)),
                      if (isVerified && isGroup) ...[const SizedBox(width: 4), const VerifiedBadge(size: 13)],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, color: AppColors.slateLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.slateLight)),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: 19, height: 19,
                    decoration: const BoxDecoration(color: AppColors.marigold, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
