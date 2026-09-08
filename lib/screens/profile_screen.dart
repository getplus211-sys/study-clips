import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';
import '../widgets/verified_badge.dart';
import '../services/auth_service.dart';
import '../services/creator_service.dart';
import 'creator_onboarding_screen.dart';
import 'auth_gate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _creatorService = CreatorService();
  bool _isCreator = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userId = _authService.currentUser?.id;
    if (userId != null) {
      final active = await _creatorService.isActiveCreator(userId);
      if (mounted) setState(() => _isCreator = active);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final email = user?.email ?? '';
    final isVerified = (user?.userMetadata?['is_verified'] as bool?) ?? false;
    final displayName = (user?.userMetadata?['name'] as String?)?.trim().isNotEmpty == true
        ? user!.userMetadata!['name'] as String
        : email;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.ink))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    UserAvatar(initials: displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : '?', radius: 34, isVerified: isVerified),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerifiedName(
                            name: displayName,
                            isVerified: isVerified,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                          ),
                          const SizedBox(height: 3),
                          Text(_isCreator ? 'Content Creator' : 'Student', style: const TextStyle(color: AppColors.slate, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _ProfileRow(icon: Icons.workspace_premium_outlined, label: 'Premium Pass', value: ''),
                const _ProfileRow(icon: Icons.receipt_long_outlined, label: 'Purchase History', value: ''),
                const _ProfileRow(icon: Icons.settings_outlined, label: 'Settings', value: ''),
                if (!_isCreator)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorOnboardingScreen())),
                      child: const Text('Creator બનો — Premium content upload કરો'),
                    ),
                  ),
                const SizedBox(height: 8),
                TextButton(onPressed: _signOut, child: const Text('Log Out', style: TextStyle(color: AppColors.coral))),
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
