import 'dart:convert';

class Products {
  final String productId;
  final String shopId;
  final String name;
  final String gender;
  final String category;
  final List<String> images;
  final double price;
  final int stock;
  final int likes;
  final int ordersCount;
  final String? sizeChart;
  final Map<String, dynamic>? sizeMeasurements;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int wish;
  final String wear;

  Products({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.gender,
    required this.category,
    required this.images,
    required this.price,
    required this.stock,
    required this.likes,
    required this.ordersCount,
    this.sizeChart,
    this.sizeMeasurements,
    required this.createdAt,
    required this.updatedAt,
    required this.wish,
    required this.wear,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['product_id'] ?? '',
      shopId: json['shop_id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: double.parse(json['price']?.toString() ?? '0'),
      stock: json['stock'] ?? 0,
      likes: json['likes'] ?? 0,
      ordersCount: json['orders_count'] ?? 0,
      sizeChart: json['size_chart'],
      sizeMeasurements: json['size_measurements'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      wish: json['wish'] ?? 0,
      wear: json['wear'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'shop_id': shopId,
      'name': name,
      'gender': gender,
      'category': category,
      'images': images,
      'price': price,
      'stock': stock,
      'likes': likes,
      'orders_count': ordersCount,
      'size_chart': sizeChart,
      'size_measurements': sizeMeasurements,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'wish': wish,
      'wear': wear,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
