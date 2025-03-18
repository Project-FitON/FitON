class CartItems {
  final String cartItemId;
  final String cartId;
  final String productId;
  final int quantity;
  final String selectedSize;
  final String selectedColor;
  final DateTime createdAt;
  final String imageUrl;
  final String productName;
  final double productPrice;

  CartItems({
    required this.cartItemId,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
    required this.createdAt,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
  });

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
      cartItemId: json['cart_item_id'] ?? '',
      cartId: json['cart_id'] ?? '',
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selected_size'] ?? 'M',
      selectedColor: json['selected_color'] ?? 'No Color',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      imageUrl: json['image_url'] ?? 'https://example.com/tshirt1.jpg',
      productName: json['product_name'] ?? 'Unnamed Product',
      productPrice: (json['product_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'selected_size': selectedSize,
      'selected_color': selectedColor,
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
      'product_name': productName,
      'product_price': productPrice,
    };
  }
}
