import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String text;
  final String time;
  final bool read;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.text,
    required this.time,
    this.read = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF2A2A2A), height: 1.4)),
                const SizedBox(height: 3),
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.slateLight)),
              ],
            ),
          ),
          if (!read)
            Container(
              margin: const EdgeInsets.only(top: 6, left: 6),
              width: 8, height: 8,
              decoration: const BoxDecoration(color: AppColors.marigold, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
