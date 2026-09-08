import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/content_card.dart';
import '../widgets/async_state_view.dart';
import '../services/premium_content_service.dart';
import '../config/app_config.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _service = PremiumContentService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchContent();
  }

  void _reload() => setState(() => _future = _service.fetchContent());

  ContentType _typeOf(String? raw) {
    switch (raw) {
      case 'test': return ContentType.test;
      case 'video': return ContentType.video;
      default: return ContentType.pdf;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            _PlanBanner(),
            const _SectionLabel('CONTENT'),
            AsyncStateView<List<Map<String, dynamic>>>(
              future: _future,
              isEmpty: (rows) => rows.isEmpty,
              emptyMessage: 'હજુ કોઈ premium content upload નથી થયું.',
              onRetry: _reload,
              builder: (context, rows) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                    children: rows.map((row) {
                      final price = (row['price'] as num?) ?? 0;
                      return ContentCard(
                        type: _typeOf(row['type'] as String?),
                        title: (row['title'] as String?) ?? '',
                        meta: price == 0 ? 'Free' : '₹$price',
                        locked: price > 0,
                        onTap: () {
                          // TODO: if locked and not purchased → open Razorpay
                          // checkout, then PremiumContentService.recordPurchase(),
                          // then getSignedUrl() to open the file.
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(
                'Video lectures roadmap ma che — હજુ PDF + Mock Test j available che.',
                style: TextStyle(fontSize: 12.5, color: AppColors.slateLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.ink, AppColors.inkSoft], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Premium Pass', style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            'બધા PDF અને Mock Test unlock કરો — ₹${AppConfig.premiumPassPriceInr}/મહિનો',
            style: const TextStyle(color: Color(0xFFC6CEE6), fontSize: 12),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(color: AppColors.marigold, borderRadius: BorderRadius.circular(10)),
            child: const Text('Upgrade કરો', style: TextStyle(color: Color(0xFF1A1200), fontWeight: FontWeight.w700, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
        child: Text(text, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.slateLight)),
      );
}
