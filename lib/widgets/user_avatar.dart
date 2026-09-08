import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'verified_badge.dart';

/// Circular avatar with initials fallback and an optional blue-tick
/// badge pinned to the bottom-right corner (used wherever a verified
/// creator's profile picture is shown).
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double radius;
  final bool isVerified;
  final Gradient? fallbackGradient;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.radius = 19,
    this.isVerified = false,
    this.fallbackGradient,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _initialsFallback(),
              )
            : _initialsFallback(),
      ),
    );

    if (!isVerified) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: VerifiedBadge(size: radius * 0.62),
          ),
        ),
      ],
    );
  }

  Widget _initialsFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: fallbackGradient ??
            const LinearGradient(
              colors: [Color(0xFFF2A20C), Color(0xFFE5484D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: radius * 0.65),
      ),
    );
  }
}
