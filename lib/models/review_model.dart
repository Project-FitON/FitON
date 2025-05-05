import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_model.dart';
import 'shop_model.dart';

class Review {
  final String reviewId;
  final String productId;
  final String buyerId;
  final String? shopId;
  final int rating;
  final String comment;
  final int likes;
  final DateTime createdAt;
  Products? product;
  ShopModel? shop;

  Review({
    required this.reviewId,
    required this.productId,
    required this.buyerId,
    this.shopId,
    required this.rating,
    required this.comment,
    required this.likes,
    required this.createdAt,
    this.product,
    this.shop,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    final shopId = data['shop_id'];
    return Review(
      reviewId: data['review_id'] ?? '',
      productId: data['product_id'] ?? '',
      buyerId: data['buyer_id'] ?? '',
      shopId: shopId != null && shopId != '' ? shopId : null,
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      likes: data['likes'] ?? 0,
      createdAt: DateTime.parse(
        data['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      product:
          data['products'] != null ? Products.fromJson(data['products']) : null,
      shop:
          data['products']?['shops'] != null
              ? ShopModel.fromJson(data['products']['shops'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'review_id': reviewId,
      'product_id': productId,
      'buyer_id': buyerId,
      'rating': rating,
      'comment': comment,
      'likes': likes,
      'created_at': createdAt.toIso8601String(),
    };

    if (shopId != null) {
      map['shop_id'] = shopId as Object;
    }

    return map;
  }

  /// Fetch all reviews from Supabase
  static Future<List<Review>> fetchReviews() async {
    final response = await Supabase.instance.client
        .from('reviews')
        .select('*, products(*)')
        .order('created_at', ascending: false);

    return response.map<Review>((data) => Review.fromMap(data)).toList();
  }
}
