import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';
import '../widgets/ad_card.dart';
import '../widgets/subject_chip.dart';
import '../utils/constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _chipIndex = 0;
  final _chips = const ['બધા', 'GPSC', 'PSI', 'Talati', 'Clerk', 'Police'];

  // TODO: replace with PostService.fetchFeed() (Supabase) — mock data below.
  final _posts = const [
    _MockPost(
      author: 'Ravi Chaudhary', initials: 'રા', verified: false, time: '2 કલાક પહેલા',
      subject: 'Gujarati Vyakaran',
      body: 'સંધિ ના નિયમો યાદ રાખવાની સરળ ટ્રિક શેર કરું છું — comment માં પૂછો જો કન્ફ્યુઝન હોય તો!',
      images: [], likes: 128, comments: 34,
    ),
    _MockPost(
      author: 'Mitali Patel', initials: 'મી', verified: true, time: '5 કલાક પહેલા',
      subject: 'Current Affairs',
      body: 'આજની PIB summary નોટ્સ ના photos.',
      images: ['https://picsum.photos/seed/studyclips1/800/500'], likes: 76, comments: 12,
    ),
    _MockPost(
      author: 'Rohan Vaghela', initials: 'રો', verified: false, time: 'Yesterday',
      subject: 'Mock Test',
      body: 'Mock test ના result screenshots.',
      images: ['https://picsum.photos/seed/studyclips2/500/500', 'https://picsum.photos/seed/studyclips3/500/500'],
      likes: 54, comments: 8,
    ),
    _MockPost(
      author: 'Dipika Vora', initials: 'દી', verified: true, time: '2 days ago',
      subject: 'Geography',
      body: 'Gujarat na nadio ane bandh na maps.',
      images: [
        'https://picsum.photos/seed/studyclips4/600/400',
        'https://picsum.photos/seed/studyclips5/300/400',
        'https://picsum.photos/seed/studyclips6/300/300',
        'https://picsum.photos/seed/studyclips7/300/300',
        'https://picsum.photos/seed/studyclips8/300/300',
      ],
      likes: 142, comments: 29,
    ),
  ];

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: Column(
        children: [
          // Sticky subject-filter row, pinned just under the app bar.
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
                  onTap: () => setState(() => _chipIndex = i),
                )),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 6, bottom: 12),
              itemCount: itemCountWithAds(_posts.length),
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
                final post = _posts[realIndexFromSlot(index)];
                return PostCard(
                  authorName: post.author,
                  isVerified: post.verified,
                  timeAgo: post.time,
                  subjectTag: post.subject,
                  body: post.body,
                  initials: post.initials,
                  imageUrls: post.images,
                  likeCount: post.likes,
                  commentCount: post.comments,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MockPost {
  final String author, initials, time, subject, body;
  final bool verified;
  final List<String> images;
  final int likes, comments;
  const _MockPost({
    required this.author, required this.initials, required this.verified, required this.time,
    required this.subject, required this.body, required this.images, required this.likes, required this.comments,
  });
}
