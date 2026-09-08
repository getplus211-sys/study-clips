import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../config/app_config.dart';
import '../services/creator_service.dart';

class CreatorOnboardingScreen extends StatefulWidget {
  const CreatorOnboardingScreen({super.key});

  @override
  State<CreatorOnboardingScreen> createState() => _CreatorOnboardingScreenState();
}

class _CreatorOnboardingScreenState extends State<CreatorOnboardingScreen> {
  final _creatorService = CreatorService();
  late final Razorpay _razorpay;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment() {
    setState(() => _processing = true);
    // NOTE: for production, create the order server-side (Edge Function)
    // so the amount can't be tampered with client-side. This direct-amount
    // checkout is fine to start with for a fixed, low-risk fee like this.
    _razorpay.open(_options());
  }

  Map<String, dynamic> _options() => {
        'key': AppConfig.razorpayKey,
        'amount': AppConfig.creatorFeeInr * 100, // paise
        'name': 'Study Clips',
        'description': 'Creator Plan — Monthly Fee',
        'prefill': {'email': Supabase.instance.client.auth.currentUser?.email ?? ''},
      };

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await _creatorService.activateCreator(userId: userId, amount: AppConfig.creatorFeeInr);
    }
    if (mounted) {
      setState(() => _processing = false);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creator plan activate થયો!')));
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    if (mounted) {
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment ના થયું: ${response.message ?? "try again"}')));
    }
  }

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
                  Text('₹${AppConfig.creatorFeeInr}/મહિનો', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processing ? null : _startPayment,
                child: _processing
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Pay & Activate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
