import 'package:flutter/material.dart';
import '../widgets/question_card.dart';
import '../widgets/ad_card.dart';
import '../utils/constants.dart';

class DiscussScreen extends StatelessWidget {
  const DiscussScreen({super.key});

  // TODO: replace with DiscussService.fetchQuestions() (Supabase) — mock data below.
  static const _questions = [
    _MockQ(subject: 'Maths', title: 'ચક્રવૃદ્ધિ વ્યાજ ના sum માં shortcut formula કોઈ સમજાવશો?', answers: '18', by: 'Kiran Rathod', verified: false, solved: true),
    _MockQ(subject: 'Reasoning', title: 'Blood relation ના પ્રશ્નો ઝડપથી કેમ solve કરવા?', answers: '6', by: 'Nikita Joshi', verified: false, solved: false),
    _MockQ(subject: 'History', title: '1857 ના વિપ્લવ ના mains answer માટે points કેટલા લખવા?', answers: '9', by: 'Ajay Thakor', verified: true, solved: false),
    _MockQ(subject: 'Polity', title: 'Fundamental Rights ane Directive Principles વચ્ચે key difference શું?', answers: '11', by: 'Foram Desai', verified: false, solved: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discuss')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('પ્રશ્ન પૂછો'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 12),
        itemCount: itemCountWithAds(_questions.length),
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
          final q = _questions[realIndexFromSlot(index)];
          return QuestionCard(
            subjectTag: q.subject,
            title: q.title,
            answerCount: q.answers,
            askedBy: q.by,
            askedByVerified: q.verified,
            solved: q.solved,
          );
        },
      ),
    );
  }
}

class _MockQ {
  final String subject, title, answers, by;
  final bool verified, solved;
  const _MockQ({required this.subject, required this.title, required this.answers, required this.by, required this.verified, required this.solved});
}
