import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SubjectChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const SubjectChip({super.key, required this.label, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.ink : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.ink : AppColors.line),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.slate,
          ),
        ),
      ),
    );
  }
}

/// Small tag used on posts/questions/content to show the subject
/// (e.g. "Gujarati Vyakaran", "Current Affairs").
class SubjectTag extends StatelessWidget {
  final String label;
  const SubjectTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3DC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.marigoldDeep),
      ),
    );
  }
}
