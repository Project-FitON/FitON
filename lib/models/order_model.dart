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

  factory Order.fromMap(Map<String, dynamic> data) {
    return Order(
      orderId: data['order_id'],
      buyerId: data['buyer_id'],
      shopId: data['shop_id'],
      status: data['status'],
      paymentMethod: data['payment_method'],
      totalPrice: data['total_price'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
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
}
