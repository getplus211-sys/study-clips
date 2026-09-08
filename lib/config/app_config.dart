/// All values here are read from --dart-define / --dart-define-from-file
/// at BUILD TIME. Nothing sensitive is hard-coded in source, so this file
/// is safe to commit to a public GitHub repo.
///
/// Local run:
///   flutter run \
///     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=eyJ... \
///     --dart-define=RAZORPAY_KEY=rzp_test_...
///
/// GitHub Actions: pass the same flags in the build step, sourced from
/// repo Settings → Secrets and variables → Actions (see
/// .github/workflows/build-apk.yml).
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('https://qzyhivhsmmnkzsldceso.supabase.co');
  static const supabaseAnonKey = String.fromEnvironment('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF6eWhpdmhzbW1ua3pzbGRjZXNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg4MDcxNjksImV4cCI6MjEwNDM4MzE2OX0.NEg22Ca6wBI_am_Kn1HbSsMyoSUOd5X3hXB0nHBCs_w');
  static const razorpayKey = String.fromEnvironment('RAZORPAY_KEY');

  /// Supabase Storage bucket for premium content (PDFs, mock-test assets).
  /// Public=false — files are served via signed URLs only (see
  /// PremiumContentService.getSignedUrl).
  static const premiumBucket = 'premium-content';

  /// Public bucket for post images / avatars (fine to be public-read).
  static const mediaBucket = 'media';

  static const premiumPassPriceInr = 149;
  static const creatorFeeInr = 500;

  static void assertConfigured() {
    assert(
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty,
      'SUPABASE_URL / SUPABASE_ANON_KEY not provided. '
      'Pass them via --dart-define at build/run time — see AppConfig doc comment.',
    );
  }
}
