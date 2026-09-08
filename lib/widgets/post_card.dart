import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';
import 'verified_badge.dart';
import 'subject_chip.dart';

class PostCard extends StatelessWidget {
  final String authorName;
  final bool isVerified;
  final String timeAgo;
  final String subjectTag;
  final String body;
  final List<String> imageUrls; // 0, 1, 2, or 5 images
  final int likeCount;
  final int commentCount;
  final String initials;

  const PostCard({
    super.key,
    required this.authorName,
    required this.timeAgo,
    required this.subjectTag,
    required this.body,
    required this.initials,
    this.isVerified = false,
    this.imageUrls = const [],
    this.likeCount = 0,
    this.commentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                UserAvatar(initials: initials, isVerified: isVerified),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerifiedName(
                        name: authorName,
                        isVerified: isVerified,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink),
                      ),
                      Text(timeAgo, style: const TextStyle(fontSize: 11.5, color: AppColors.slateLight)),
                    ],
                  ),
                ),
                SubjectTag(label: subjectTag),
              ],
            ),
          ),
          if (body.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Text(body, style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF2A2A2A))),
            ),
          if (imageUrls.isNotEmpty) _MediaGrid(urls: imageUrls),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              children: [
                _ActionIcon(icon: Icons.favorite_border, label: '$likeCount'),
                const SizedBox(width: 18),
                _ActionIcon(icon: Icons.chat_bubble_outline, label: '$commentCount'),
                const SizedBox(width: 18),
                const _ActionIcon(icon: Icons.share_outlined, label: 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.slate),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.slate)),
      ],
    );
  }
}

/// Handles 1 / 2 / 5-image layouts matching the web mockup.
class _MediaGrid extends StatelessWidget {
  final List<String> urls;
  const _MediaGrid({required this.urls});

  Widget _img(String url, {BoxFit fit = BoxFit.cover}) =>
      CachedNetworkImage(imageUrl: url, fit: fit, width: double.infinity, height: double.infinity);

  @override
  Widget build(BuildContext context) {
    if (urls.length == 1) {
      return SizedBox(height: 220, child: _img(urls[0]));
    }
    if (urls.length == 2) {
      return SizedBox(
        height: 160,
        child: Row(
          children: [
            Expanded(child: _img(urls[0])),
            const SizedBox(width: 2),
            Expanded(child: _img(urls[1])),
          ],
        ),
      );
    }
    // 5-image layout: 1 large + 4 small (last one shows "+N" overlay if more)
    final extra = urls.length > 5 ? urls.length - 5 : 0;
    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(flex: 2, child: _img(urls[0])),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              children: [
                Expanded(child: Row(children: [Expanded(child: _img(urls[1])), const SizedBox(width: 2), Expanded(child: _img(urls[2]))])),
                const SizedBox(height: 2),
                Expanded(
                  child: Row(children: [
                    Expanded(child: _img(urls[3])),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _img(urls[4]),
                          if (extra > 0)
                            Container(
                              color: Colors.black.withOpacity(0.55),
                              alignment: Alignment.center,
                              child: Text('+$extra', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                            ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
