import 'package:flutter/material.dart';
import '../widgets/question_card.dart';
import '../widgets/ad_card.dart';
import '../widgets/async_state_view.dart';
import '../services/discuss_service.dart';
import '../utils/constants.dart';

class DiscussScreen extends StatefulWidget {
  const DiscussScreen({super.key});

  @override
  State<DiscussScreen> createState() => _DiscussScreenState();
}

class _DiscussScreenState extends State<DiscussScreen> {
  final _discussService = DiscussService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _discussService.fetchQuestions();
  }

  void _reload() => setState(() => _future = _discussService.fetchQuestions());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discuss')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: open Ask Question form → DiscussService.askQuestion(...)
        },
        icon: const Icon(Icons.add),
        label: const Text('પ્રશ્ન પૂછો'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: AsyncStateView<List<Map<String, dynamic>>>(
          future: _future,
          isEmpty: (rows) => rows.isEmpty,
          emptyMessage: 'હજુ કોઈ discussion નથી — પ્રથમ પ્રશ્ન તમે પૂછો!',
          onRetry: _reload,
          builder: (context, rows) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 12),
              itemCount: itemCountWithAds(rows.length),
              itemBuilder: (context, index) {
                if (isAdSlot(index)) {
                  return const AdCard(
                    advertiserName: 'Gyan Sarovar Publications',
                    bannerUrl: 'https://picsum.photos/seed/studyclipsad2/800/400',
                    title: 'Talati-Clerk Complete Guide — હવે ₹199 માં',
                    subtitle: 'Updated Syllabus 2026 · Free Home Delivery',
                    ctaLabel: 'ઓર્ડર કરો',
                    logoIcon: Icons.menu_book_outlined,
                    logoBg: Color(0xFFFFF3DC),
                    logoColor: Color(0xFFC97F00),
                  );
                }
                final row = rows[realIndexFromSlot(index)];
                final user = row['users'] as Map<String, dynamic>? ?? {};
                final replies = row['discussion_replies'] as List? ?? const [];
                final replyCount = replies.isNotEmpty ? (replies.first['count'] ?? 0) : 0;
                return QuestionCard(
                  subjectTag: (row['subject'] as String?) ?? '',
                  title: (row['title'] as String?) ?? '',
                  answerCount: '$replyCount',
                  askedBy: (user['name'] as String?) ?? 'Student',
                  askedByVerified: (user['is_verified'] as bool?) ?? false,
                  solved: (row['solved'] as bool?) ?? false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
