class Wishlist {
  final String wishlistId;
  final String buyerId;
  final String productId;
  final DateTime createdAt;

  Wishlist({
    required this.wishlistId,
    required this.buyerId,
    required this.productId,
    required this.createdAt,
  });

  factory Wishlist.fromMap(Map<String, dynamic> data) {
    return Wishlist(
      wishlistId: data['wishlist_id'],
      buyerId: data['buyer_id'],
      productId: data['product_id'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wishlist_id': wishlistId,
      'buyer_id': buyerId,
      'product_id': productId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
