import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/content_card.dart';
import '../utils/constants.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _PlanBanner(),
          const _SectionLabel('MOCK TESTS'),
          _ContentGrid(items: [
            ContentCard(type: ContentType.test, title: 'GPSC Prelims Full Mock #12', meta: '100 Questions · Mock Test', locked: true, onTap: () {}),
            ContentCard(type: ContentType.test, title: 'Talati Free Mock #03', meta: '50 Questions · Free', locked: false, onTap: () {}),
          ]),
          const _SectionLabel('PDF NOTES'),
          _ContentGrid(items: [
            ContentCard(type: ContentType.pdf, title: 'Gujarat na Mela ane Utsav', meta: '24 Pages · PDF', locked: true, onTap: () {}),
            ContentCard(type: ContentType.pdf, title: 'Bandharan Sudhara List', meta: '12 Pages · PDF', locked: true, onTap: () {}),
          ]),
          const _SectionLabel('MOCK/VIDEO — coming later'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              'Video lectures roadmap ma che — R2 bandwidth-friendly rollout plan pachi add thashe.',
              style: TextStyle(fontSize: 12.5, color: AppColors.slateLight),
            ),
          ),
        ],
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
            'બધા PDF, Mock Test અને Video Lecture unlock કરો — ₹${AppConstants.premiumPassPriceInr}/મહિનો',
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

class _ContentGrid extends StatelessWidget {
  final List<Widget> items;
  const _ContentGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
        children: items,
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
