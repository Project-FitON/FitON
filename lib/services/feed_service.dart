import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/review_model.dart';
import '../models/product_model.dart';

class FeedService {
  static final supabase = Supabase.instance.client;

  // Fetch feed items with pagination
  static Future<List<Review>> getFeedItems({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await supabase
          .from('reviews')
          .select('''
            review_id,
            product_id,
            buyer_id,
            shop_id,
            rating,
            comment,
            likes,
            created_at,
            products (
              product_id,
              shop_id,
              name,
              gender,
              category,
              images,
              price,
              stock,
              likes,
              orders_count,
              size_chart,
              size_measurements,
              created_at,
              updated_at,
              wish,
              wear,
              shops (
                shop_id,
                shop_name,
                profile_photo,
                cover_photo
              )
            )
          ''')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (response == null) {
        print('No data received from Supabase');
        return [];
      }

      final List<Review> reviews = [];
      for (var data in response) {
        try {
          final review = Review.fromMap(data);
          reviews.add(review);
        } catch (e) {
          print('Error parsing review data: $e');
          print('Data that caused error: $data');
          continue;
        }
      }
      return reviews;
    } catch (e) {
      print('Error fetching feed items: $e');
      return [];
    }
  }

  // Update like count for a review
  static Future<bool> updateLikes(String reviewId, int newLikeCount) async {
    try {
      await supabase
          .from('reviews')
          .update({'likes': newLikeCount})
          .eq('review_id', reviewId);
      return true;
    } catch (e) {
      print('Error updating likes: $e');
      return false;
    }
  }

  // Get user's favorite reviews
  static Future<List<String>> getFavorites(String userId) async {
    try {
      final response = await supabase
          .from('favorites')
          .select('review_id')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => item['review_id'] as String)
          .toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  // Toggle favorite status
  static Future<bool> toggleFavorite(String userId, String reviewId) async {
    try {
      // First check if the favorite exists
      final response = await supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('review_id', reviewId);

      if (response.isEmpty) {
        // If no favorite exists, insert a new one
        await supabase.from('favorites').insert({
          'user_id': userId,
          'review_id': reviewId,
        });
      } else {
        // If favorite exists, delete it
        await supabase
            .from('favorites')
            .delete()
            .eq('user_id', userId)
            .eq('review_id', reviewId);
      }
      return true;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
}
