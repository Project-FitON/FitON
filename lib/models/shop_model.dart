import 'dart:convert';

class ShopModel {
  final String shopId;
  final String shopName;
  final String? nickname;
  final String? phoneNumber;
  final String? email;
  final String? passwordHash;
  final String? profilePhoto;
  final String? coverPhoto;
  final String? paypalEmail;
  final String? bankAccountNumber;
  final String? bankName;
  final String? upiId;
  final bool? cashOnDelivery;
  final int followers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShopModel({
    required this.shopId,
    required this.shopName,
    this.nickname,
    this.phoneNumber,
    this.email,
    this.passwordHash,
    this.profilePhoto,
    this.coverPhoto,
    this.paypalEmail,
    this.bankAccountNumber,
    this.bankName,
    this.upiId,
    this.cashOnDelivery,
    this.followers = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      shopId: json['shop_id'] ?? '',
      shopName: json['shop_name'] ?? '',
      nickname: json['nickname'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      passwordHash: json['password_hash'],
      profilePhoto: json['profile_photo'],
      coverPhoto: json['cover_photo'],
      paypalEmail: json['paypal_email'],
      bankAccountNumber: json['bank_account_number'],
      bankName: json['bank_name'],
      upiId: json['upi_id'],
      cashOnDelivery: json['cash_on_delivery'],
      followers: json['followers'] ?? 0,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'nickname': nickname,
      'phone_number': phoneNumber,
      'email': email,
      'password_hash': passwordHash,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'paypal_email': paypalEmail,
      'bank_account_number': bankAccountNumber,
      'bank_name': bankName,
      'upi_id': upiId,
      'cash_on_delivery': cashOnDelivery,
      'followers': followers,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
