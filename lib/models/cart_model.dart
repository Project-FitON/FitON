class Cart {
  final String cartId;
  final String buyerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.cartId,
    required this.buyerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'] as String,
      buyerId: json['buyer_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'buyer_id': buyerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
