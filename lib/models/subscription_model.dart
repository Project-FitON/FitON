class Subscription {
  final String subscriptionId;
  final String buyerId;
  final String shopId;
  final String planId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Subscription({
    required this.subscriptionId,
    required this.buyerId,
    required this.shopId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptionId: json['subscription_id'] as String,
      buyerId: json['buyer_id'] as String,
      shopId: json['shop_id'] as String,
      planId: json['plan_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'buyer_id': buyerId,
      'shop_id': shopId,
      'plan_id': planId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
