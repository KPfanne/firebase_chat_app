class AppUser {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}
