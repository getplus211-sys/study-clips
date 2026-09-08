import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';
import '../widgets/verified_badge.dart';
import 'creator_onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  // TODO: replace with the logged-in AppUser from AuthService.
  final bool isVerified;
  final bool isCreator;
  const ProfileScreen({super.key, this.isVerified = true, this.isCreator = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              UserAvatar(initials: 'વે', radius: 34, isVerified: isVerified),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerifiedName(
                      name: 'Ved Patel',
                      isVerified: isVerified,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                    ),
                    const SizedBox(height: 3),
                    Text(isCreator ? 'Content Creator' : 'Student', style: const TextStyle(color: AppColors.slate, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ProfileRow(icon: Icons.workspace_premium_outlined, label: 'Premium Pass', value: 'Active'),
          _ProfileRow(icon: Icons.receipt_long_outlined, label: 'Purchase History', value: ''),
          _ProfileRow(icon: Icons.settings_outlined, label: 'Settings', value: ''),
          if (!isCreator)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorOnboardingScreen())),
                child: const Text('Creator બનો — Premium content upload કરો'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ProfileRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.ink),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: value.isNotEmpty
          ? Text(value, style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 12.5))
          : const Icon(Icons.chevron_right, color: AppColors.slateLight),
    );
  }
}
