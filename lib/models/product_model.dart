import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductModel {
  final String productId;
  final String shopId;
  final String name;
  final String description;
  final String category;
  final List<String> images;
  final double price;
  final double originalPrice;
  final int stock;
  final int likes;
  final int ordersCount;
  final String? sizeChart;
  final Map<String, dynamic>? sizeMeasurements;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.description,
    required this.category,
    required this.images,
    required this.price,
    required this.originalPrice,
    required this.stock,
    required this.likes,
    required this.ordersCount,
    this.sizeChart,
    this.sizeMeasurements,
    required this.createdAt,
    required this.updatedAt,
  });

  int get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - price) / originalPrice * 100).round();
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing JSON data: $json');
      
      // Helper function to safely parse double values
      double parseDouble(dynamic value) {
        if (value == null) return 0.0;
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
      }

      // Helper function to safely parse int values
      int parseInt(dynamic value) {
        if (value == null) return 0;
        if (value is num) return value.toInt();
        if (value is String) return int.tryParse(value) ?? 0;
        return 0;
      }

      return ProductModel(
        productId: json['product_id']?.toString() ?? '',
        shopId: json['shop_id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Unnamed Product',
        description: json['description']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        images: List<String>.from(json['images'] ?? []),
        price: parseDouble(json['price']),
        originalPrice: parseDouble(json['original_price']),
        stock: parseInt(json['stock']),
        likes: parseInt(json['likes']),
        ordersCount: parseInt(json['orders_count']),
        sizeChart: json['size_chart']?.toString(),
        sizeMeasurements: json['size_measurements'] as Map<String, dynamic>?,
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      );
    } catch (e, stackTrace) {
      print('Error parsing product JSON: $e');
      print('Stack trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow;
    }
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
      'original_price': originalPrice,
      'stock': stock,
      'likes': likes,
      'orders_count': ordersCount,
      'size_chart': sizeChart,
      'size_measurements': sizeMeasurements,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static Future<List<ProductModel>> fetchProducts() async {
    try {
      print('Fetching products from Supabase...');
      
      // Verify Supabase connection
      final client = Supabase.instance.client;
      if (client == null) {
        throw Exception('Supabase client is not initialized');
      }

      print('Checking products table...');
      final response = await client
          .from('products')
          .select('*')
          .gt('stock', 0)
          .order('created_at', ascending: false);

      print('Raw Supabase response: $response');

      if (response == null) {
        print('Response is null');
        return [];
      }

      if (response is! List) {
        print('Response is not a List: ${response.runtimeType}');
        throw Exception('Unexpected response format');
      }

      final products = response.map((data) {
        try {
          print('Processing product data: $data');
          return ProductModel.fromJson(data);
        } catch (e) {
          print('Error parsing product: $e');
          print('Problematic data: $data');
          rethrow;
        }
      }).toList();

      print('Successfully fetched ${products.length} products');
      return products;
    } on PostgrestException catch (e) {
      print('Supabase error: ${e.message}');
      print('Error details: ${e.details}');
      rethrow;
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  static Future<ProductModel?> fetchProductById(String id) async {
    final response = await Supabase.instance.client
        .from('products')
        .select()
        .eq('product_id', id)
        .single();

    return response != null ? ProductModel.fromJson(response) : null;
  }

  @override
  String toString() => jsonEncode(toJson());
}
