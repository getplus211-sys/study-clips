import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The blue verified tick — drop this next to any name/avatar for a
/// verified creator or mentor. Used consistently across post cards,
/// discuss cards, chat tiles, profile headers, and creator dashboards.
class VerifiedBadge extends StatelessWidget {
  final double size;
  const VerifiedBadge({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.blueTick,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, color: Colors.white, size: size * 0.65),
    );
  }
}

/// Wraps a name with the blue tick when [isVerified] is true.
/// Use this everywhere a user's display name is rendered so verified
/// status shows up consistently across the whole app.
class VerifiedName extends StatelessWidget {
  final String name;
  final bool isVerified;
  final TextStyle? style;

  const VerifiedName({
    super.key,
    required this.name,
    required this.isVerified,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            name,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isVerified) ...[
          const SizedBox(width: 4),
          const VerifiedBadge(),
        ],
      ],
    );
  }
}
