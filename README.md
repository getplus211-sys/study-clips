# Study Clips

Gujarati-language student social app — Feed, Discuss, Chats, Notifications, Premium content (PDF + Mock Tests), with a Creator economy (fixed monthly fee to upload) and native ads every 3-4 items in Feed/Discuss.

## Design
- **Background:** white throughout (`AppColors.background` / `Colors.white`)
- **Header/Nav:** deep ink navy (`#14213D`)
- **Accent:** marigold (`#F2A20C`)
- **Fonts:** Inter (UI/Latin) + Noto Sans Gujarati (Gujarati script), loaded via `google_fonts` — no manual font files needed
- **Blue verified tick:** `lib/widgets/verified_badge.dart` — `VerifiedBadge` (the tick itself) and `VerifiedName` (name + tick together). Used consistently in `PostCard`, `QuestionCard`, `ChatTile`, `UserAvatar`, and `ProfileScreen` wherever a verified creator's name/avatar appears — just pass `isVerified: true`.

## Project structure
```
lib/
  main.dart                    — app entry, Supabase init
  theme/app_theme.dart         — colors, fonts, ThemeData
  models/user_model.dart
  widgets/                     — PostCard, AdCard, QuestionCard, ChatTile,
                                  ContentCard, NotificationTile, UserAvatar,
                                  VerifiedBadge/VerifiedName, SubjectChip
  screens/                     — Splash, Login, HomeShell (bottom nav),
                                  Feed, Discuss, Chats, ChatRoom, Premium,
                                  Notifications, Profile, CreatorOnboarding
  services/                    — Auth, Post, Discuss, Chat, PremiumContent,
                                  Creator, Storage (R2), Notification (FCM)
  utils/constants.dart         — ad-slot math, API keys placeholder
```

## Before running
1. `flutter pub get`
2. Fill in `lib/utils/constants.dart`:
   - `supabaseUrl`, `supabaseAnonKey` — from your Supabase project
   - `razorpayKey` — for creator-fee and premium-content payments
   - `r2AccountId`, `r2BucketName` — Cloudflare R2 bucket for PDFs/mock-test assets
3. Set up Supabase tables (see comments at the top of each file in `lib/services/`) — `users`, `posts`, `likes`, `discussions`, `discussion_replies`, `chats`, `chat_participants`, `chat_messages`, `premium_content`, `creators`, `creator_subscriptions`, `purchases`.
4. For push notifications, drop your `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) into the platform folders and run `flutterfire configure`.
5. R2 file access goes through a Supabase Edge Function that returns presigned S3-style URLs — see `lib/services/storage_service.dart` for the two calls you need to implement (upload + download).

## Ad placement
`lib/utils/constants.dart` has `adFrequency = 3` and three helper functions (`itemCountWithAds`, `isAdSlot`, `realIndexFromSlot`) that interleave one `AdCard` after every 3 organic items in both `FeedScreen` and `DiscussScreen` — change `adFrequency` in one place to retune the whole app.

## Monetization recap
- Students: free app access, see ads (every 3-4 feed/discuss items)
- Creators: pay a **fixed** monthly fee (`AppConstants.creatorFeeInr`) to unlock premium-content uploads
- Students pay separately to unlock individual premium content; app currently takes **no cut** beyond payment-gateway fee + GST (revenue-share planned later once purchase volume grows)

## Not included yet
- Video lectures (explicitly deferred — PDF + Mock Test only for now)
- Server-side revenue-share logic (flagged as a future iteration)
- Actual Edge Functions for R2 presigning and FCM push dispatch (stubbed with `TODO`s)
