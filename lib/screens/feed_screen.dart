import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';
import '../widgets/ad_card.dart';
import '../widgets/subject_chip.dart';
import '../widgets/async_state_view.dart';
import '../services/post_service.dart';
import '../utils/constants.dart';
import 'profile_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _postService = PostService();
  int _chipIndex = 0;
  final _chips = const ['બધા', 'GPSC', 'PSI', 'Talati', 'Clerk', 'Police'];
  late Future<List<Map<String, dynamic>>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _postService.fetchFeed();
  }

  void _reload({String? subject}) {
    setState(() => _feedFuture = _postService.fetchFeed(subjectFilter: subject));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(children: [
            TextSpan(text: 'Study', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            TextSpan(text: 'Clips', style: TextStyle(color: AppColors.marigold, fontWeight: FontWeight.w800)),
          ]),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_chips.length, (i) => SubjectChip(
                  label: _chips[i],
                  active: i == _chipIndex,
                  onTap: () {
                    setState(() => _chipIndex = i);
                    _reload(subject: _chips[i]);
                  },
                )),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _reload(subject: _chips[_chipIndex]),
              child: AsyncStateView<List<Map<String, dynamic>>>(
                future: _feedFuture,
                isEmpty: (rows) => rows.isEmpty,
                emptyMessage: 'આ subject માં હજુ કોઈ post નથી.',
                onRetry: () => _reload(subject: _chips[_chipIndex]),
                builder: (context, rows) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    itemCount: itemCountWithAds(rows.length),
                    itemBuilder: (context, index) {
                      if (isAdSlot(index)) {
                        return const AdCard(
                          advertiserName: 'Career Point Academy',
                          bannerUrl: 'https://picsum.photos/seed/studyclipsad1/800/400',
                          title: 'GPSC Class 1-2 નવી બેચ — Admission ચાલુ',
                          subtitle: 'Live + Recorded Lectures · Gujarati Medium',
                          ctaLabel: 'વધુ જાણો',
                          logoIcon: Icons.menu_book_outlined,
                        );
                      }
                      final row = rows[realIndexFromSlot(index)];
                      final user = row['users'] as Map<String, dynamic>? ?? {};
                      final images = (row['image_urls'] as List?)?.cast<String>() ?? const <String>[];
                      final name = (user['name'] as String?) ?? 'Student';
                      return PostCard(
                        authorName: name,
                        isVerified: (user['is_verified'] as bool?) ?? false,
                        timeAgo: _timeAgo(row['created_at'] as String?),
                        subjectTag: (row['subject'] as String?) ?? '',
                        body: (row['body'] as String?) ?? '',
                        initials: name.isNotEmpty ? name.substring(0, 1) : '?',
                        imageUrls: images,
                        likeCount: (row['like_count'] as int?) ?? 0,
                        commentCount: (row['comment_count'] as int?) ?? 0,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} મિનિટ પહેલા';
    if (diff.inHours < 24) return '${diff.inHours} કલાક પહેલા';
    return '${diff.inDays} દિવસ પહેલા';
  }
}
