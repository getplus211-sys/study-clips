import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ContentType { pdf, test, video }

class ContentCard extends StatelessWidget {
  final ContentType type;
  final String title;
  final String meta;
  final bool locked;
  final VoidCallback? onTap;

  const ContentCard({
    super.key,
    required this.type,
    required this.title,
    required this.meta,
    this.locked = true,
    this.onTap,
  });

  Color get _bg {
    switch (type) {
      case ContentType.pdf: return const Color(0xFFFDEDED);
      case ContentType.test: return const Color(0xFFEAF3FF);
      case ContentType.video: return const Color(0xFFFFF3DC);
    }
  }

  Color get _iconColor {
    switch (type) {
      case ContentType.pdf: return AppColors.coral;
      case ContentType.test: return const Color(0xFF2563EB);
      case ContentType.video: return AppColors.marigoldDeep;
    }
  }

  IconData get _icon {
    switch (type) {
      case ContentType.pdf: return Icons.picture_as_pdf_outlined;
      case ContentType.test: return Icons.fact_check_outlined;
      case ContentType.video: return Icons.play_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(height: 74, width: double.infinity, color: _bg, alignment: Alignment.center, child: Icon(_icon, color: _iconColor, size: 26)),
                if (locked)
                  Positioned(
                    top: 7, right: 7,
                    child: Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(color: AppColors.ink.withOpacity(0.85), borderRadius: BorderRadius.circular(7)),
                      child: const Icon(Icons.lock_outline, color: Colors.white, size: 11),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.35)),
                  const SizedBox(height: 4),
                  Text(meta, style: const TextStyle(fontSize: 10.5, color: AppColors.slateLight, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
