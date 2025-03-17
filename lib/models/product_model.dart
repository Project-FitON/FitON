import 'dart:convert';

class Products {
  final String productId;
  final String shopId;
  final String name;
  final String description;
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

  Products({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.description,
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
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['product_id'],
      shopId: json['shop_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      images: List<String>.from(json['images'] ?? []),
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      likes: json['likes'],
      ordersCount: json['orders_count'],
      sizeChart: json['size_chart'],
      sizeMeasurements: json['size_measurements'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'shop_id': shopId,
      'name': name,
      'description': description,
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
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
