import 'dart:convert';

class Buyer {
  final String buyerId;
  final String nickname;
  final String phoneNumber;
  final String email;
  final String passwordHash;
  final DateTime dateOfBirth;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> interests;
  final bool recommendationOptOut;

  Buyer({
    required this.buyerId,
    required this.nickname,
    required this.phoneNumber,
    required this.email,
    required this.passwordHash,
    required this.dateOfBirth,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.interests,
    required this.recommendationOptOut,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      buyerId: json['buyer_id'],
      nickname: json['nickname'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      passwordHash: json['password_hash'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      interests: List<String>.from(json['interests'] ?? []),
      recommendationOptOut: json['recommendation_opt_out'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyer_id': buyerId,
      'nickname': nickname,
      'phone_number': phoneNumber,
      'email': email,
      'password_hash': passwordHash,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'interests': interests,
      'recommendation_opt_out': recommendationOptOut,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}