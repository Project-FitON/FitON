class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String planType;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.planType,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      planType: map['planType'] ?? 'Free Plan',
      createdAt:
          map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'planType': planType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
