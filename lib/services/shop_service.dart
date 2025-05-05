import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' as math;

class ShopService {
  static final _supabase = Supabase.instance.client;

  static bool _isValidUUID(String? uuid) {
    if (uuid == null || uuid.isEmpty) return false;
    return true;
  }

  static Future<int> _getFollowersCount(String shopId) async {
    try {
      if (!_isValidUUID(shopId)) return 0;

      final response = await _supabase
          .from('followers')
          .select()
          .eq('shop_id', shopId);

      return (response as List).length;
    } catch (e) {
      print('Error getting followers count: $e');
      return 0;
    }
  }

  static Future<bool> _ensureBuyerExists(String userId) async {
    try {
      if (!_isValidUUID(userId)) return false;

      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // First check if buyer exists by buyer_id
      var buyer =
          await _supabase
              .from('buyers')
              .select()
              .eq('buyer_id', userId)
              .maybeSingle();

      // If not found by buyer_id, check by email
      if (buyer == null && user.email != null) {
        final userEmail =
            user.email!; // Non-null assertion since we checked above
        buyer =
            await _supabase
                .from('buyers')
                .select()
                .eq('email', userEmail)
                .maybeSingle();

        // If found by email, update the buyer_id to match the current user
        if (buyer != null) {
          await _supabase
              .from('buyers')
              .update({'buyer_id': userId})
              .eq('email', userEmail);
          return true;
        }
      }

      if (buyer != null) return true;

      // If buyer doesn't exist at all, create new one
      final userEmail = user.email ?? '';
      String nickname = (userEmail.split('@')[0]).substring(
        0,
        math.min(userEmail.split('@')[0].length, 50),
      );

      await _supabase.from('buyers').insert({
        'buyer_id': userId,
        'nickname': nickname,
        'phone_number': '0000000000',
        'email': userEmail.substring(0, math.min(userEmail.length, 50)),
        'password_hash': 'temp_hash',
        'date_of_birth': DateTime.now().toIso8601String().split('T')[0],
        'gender': 'M',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'interests': [],
        'recommendation_opt_out': false,
        'address': '',
      });

      return true;
    } catch (e) {
      print('Error ensuring buyer exists: $e');
      return false;
    }
  }

  static Future<bool> followShop(String? shopId) async {
    try {
      if (!_isValidUUID(shopId)) {
        print('Invalid shop ID');
        return false;
      }

      final userId = _supabase.auth.currentUser?.id;
      if (!_isValidUUID(userId)) {
        print('Invalid user ID');
        return false;
      }

      // Ensure buyer exists before following
      final buyerExists = await _ensureBuyerExists(userId!);
      if (!buyerExists) return false;

      // Add follower record
      await _supabase.from('followers').insert({
        'shop_id': shopId!,
        'buyer_id': userId,
        'date': DateTime.now().toIso8601String(),
      });

      // Get updated followers count
      final followersCount = await _getFollowersCount(shopId);

      // Notify UI of the new count through a realtime subscription
      await _supabase
          .from('shops')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('shop_id', shopId);

      return true;
    } catch (e) {
      print('Error following shop: $e');
      return false;
    }
  }

  static Future<bool> unfollowShop(String? shopId) async {
    try {
      if (!_isValidUUID(shopId)) {
        print('Invalid shop ID');
        return false;
      }

      final userId = _supabase.auth.currentUser?.id;
      if (!_isValidUUID(userId)) {
        print('Invalid user ID');
        return false;
      }

      await _supabase.from('followers').delete().match({
        'shop_id': shopId!,
        'buyer_id': userId!,
      });

      // Get updated followers count
      final followersCount = await _getFollowersCount(shopId);

      // Notify UI of the new count through a realtime subscription
      await _supabase
          .from('shops')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('shop_id', shopId);

      return true;
    } catch (e) {
      print('Error unfollowing shop: $e');
      return false;
    }
  }

  static Future<bool> isFollowingShop(String? shopId) async {
    try {
      if (!_isValidUUID(shopId)) return false;

      final userId = _supabase.auth.currentUser?.id;
      if (!_isValidUUID(userId)) return false;

      final response =
          await _supabase.from('followers').select().match({
            'shop_id': shopId!,
            'buyer_id': userId!,
          }).single();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getShopFollowersCount(String shopId) async {
    return await _getFollowersCount(shopId);
  }
}
