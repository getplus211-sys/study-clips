/// How many organic items appear between native ad slots in Feed/Discuss.
/// One ad is inserted after every [adFrequency]-th organic item.
const int adFrequency = 3;

/// Given the real number of organic items, returns the total list length
/// once ad slots are interleaved (used as `itemCount` in ListView.builder).
int itemCountWithAds(int organicCount) {
  final adSlots = organicCount ~/ adFrequency;
  return organicCount + adSlots;
}

/// Whether the given position in the combined (posts + ads) list is an
/// ad slot rather than an organic item.
bool isAdSlot(int combinedIndex) {
  final position = combinedIndex + 1;
  return position % (adFrequency + 1) == 0;
}

/// Maps a combined-list index back to the real index into the organic
/// (posts/questions) data list, skipping over ad slots.
int realIndexFromSlot(int combinedIndex) {
  final adsBefore = (combinedIndex + 1) ~/ (adFrequency + 1);
  return combinedIndex - adsBefore;
}

class AppConstants {
  static const supabaseUrl = 'YOUR_SUPABASE_URL';
  static const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const razorpayKey = 'YOUR_RAZORPAY_KEY';
  static const r2AccountId = 'YOUR_CLOUDFLARE_R2_ACCOUNT_ID';
  static const r2BucketName = 'study-clips-content';
  static const premiumPassPriceInr = 149;
  static const creatorFeeInr = 500;
}
