import 'dart:convert';

class Order {
  final String orderId;
  final String buyerId;
  final String shopId;
  final String status;
  final String paymentMethod;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.orderId,
    required this.buyerId,
    required this.shopId,
    required this.status,
    required this.paymentMethod,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      buyerId: json['buyer_id'],
      shopId: json['shop_id'],
      status: json['status'],
      paymentMethod: json['payment_method'],
      totalPrice: json['total_price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'buyer_id': buyerId,
      'shop_id': shopId,
      'status': status,
      'payment_method': paymentMethod,
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
