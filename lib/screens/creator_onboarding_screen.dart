import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class CreatorOnboardingScreen extends StatelessWidget {
  const CreatorOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creator બનો')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Premium content (PDF, Mock Test) upload karva mate fixed monthly fee pay karo.',
              style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF2A2A2A)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F5EF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Creator Plan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Text('₹${AppConstants.creatorFeeInr}/મહિનો', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: CreatorService.payFeeAndActivate() via Razorpay, then unlock upload dashboard.
                },
                child: const Text('Pay & Activate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
