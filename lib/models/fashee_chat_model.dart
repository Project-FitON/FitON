import 'dart:convert';

class FasheeChatModel {
  final String chatId;
  final String buyerId;
  final String dependentId;
  final Map<String, dynamic> messages;
  final DateTime createdAt;

  FasheeChatModel({
    required this.chatId,
    required this.buyerId,
    required this.dependentId,
    required this.messages,
    required this.createdAt,
  });

  factory FasheeChatModel.fromJson(Map<String, dynamic> json) {
    return FasheeChatModel(
      chatId: json['chat_id'],
      buyerId: json['buyer_id'],
      dependentId: json['dependent_id'],
      messages: json['messages'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'buyer_id': buyerId,
      'dependent_id': dependentId,
      'messages': messages,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
