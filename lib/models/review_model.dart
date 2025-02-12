import 'package:supabase_flutter/supabase_flutter.dart';

class Review {
  final String reviewId;
  final String productId;
  final String buyerId;
  final int rating;
  final String comment;
  final int likes;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.productId,
    required this.buyerId,
    required this.rating,
    required this.comment,
    required this.likes,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      reviewId: data['review_id'],
      productId: data['product_id'],
      buyerId: data['buyer_id'],
      rating: data['rating'],
      comment: data['comment'],
      likes: data['likes'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'review_id': reviewId,
      'product_id': productId,
      'buyer_id': buyerId,
      'rating': rating,
      'comment': comment,
      'likes': likes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Fetch all reviews from Supabase
  static Future<List<Review>> fetchReviews() async {
    final response = await Supabase.instance.client
        .from('reviews')
        .select()
        .order('created_at', ascending: false);

    return response.map<Review>((data) => Review.fromMap(data)).toList();
  }
}
