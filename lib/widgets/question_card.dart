import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'subject_chip.dart';
import 'verified_badge.dart';

class QuestionCard extends StatelessWidget {
  final String subjectTag;
  final String title;
  final String answerCount;
  final String askedBy;
  final bool askedByVerified;
  final bool solved;

  const QuestionCard({
    super.key,
    required this.subjectTag,
    required this.title,
    required this.answerCount,
    required this.askedBy,
    this.askedByVerified = false,
    this.solved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubjectTag(label: subjectTag),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.4)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: Text('$answerCount જવાબ · $askedBy', style: const TextStyle(fontSize: 12, color: AppColors.slateLight), overflow: TextOverflow.ellipsis)),
                    if (askedByVerified) ...[const SizedBox(width: 4), const VerifiedBadge(size: 12)],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: solved ? const Color(0xFFE8F5EC) : const Color(0xFFFFF3DC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  solved ? 'Solved' : 'Open',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: solved ? AppColors.green : AppColors.marigoldDeep),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
