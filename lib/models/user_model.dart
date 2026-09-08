class AppUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isVerified; // blue tick — shown for verified creators/mentors
  final bool isCreator;

  const AppUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isVerified = false,
    this.isCreator = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      isVerified: map['is_verified'] as bool? ?? false,
      isCreator: map['is_creator'] as bool? ?? false,
    );
  }
}
