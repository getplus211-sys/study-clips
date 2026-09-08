import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

/// Native-style sponsored ad card. Shown after every 3-4 organic
/// items in Feed and Discuss (see [adSlotIndex] helper in utils/constants.dart).
class AdCard extends StatelessWidget {
  final String advertiserName;
  final String bannerUrl;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final IconData logoIcon;
  final Color logoBg;
  final Color logoColor;
  final VoidCallback? onTap;

  const AdCard({
    super.key,
    required this.advertiserName,
    required this.bannerUrl,
    required this.title,
    required this.subtitle,
    this.ctaLabel = 'Know More',
    this.logoIcon = Icons.school_outlined,
    this.logoBg = const Color(0xFFEAF3FF),
    this.logoColor = const Color(0xFF2563EB),
    this.onTap,
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: logoBg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(logoIcon, color: logoColor, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(advertiserName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
                      const Text('Sponsored', style: TextStyle(fontSize: 11, color: AppColors.slateLight)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CachedNetworkImage(imageUrl: bannerUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.4)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 12.5, color: AppColors.slate)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onTap, child: Text(ctaLabel)),
            ),
          ),
        ],
      ),
    );
  }
}
