import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  static final _supabase = Supabase.instance.client;

  static Future<String?> getOrCreateCart() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      // Try to get existing cart
      final cartResponse =
          await _supabase
              .from('cart')
              .select()
              .eq('buyer_id', userId)
              .maybeSingle();

      if (cartResponse != null) {
        return cartResponse['cart_id'];
      }

      // Create new cart if none exists
      final newCart =
          await _supabase.from('cart').insert({
            'buyer_id': userId,
            'created_at': DateTime.now().toIso8601String(),
          }).select();

      if (newCart.isEmpty) return null;
      return newCart[0]['cart_id'];
    } catch (e) {
      print('Error getting/creating cart: $e');
      return null;
    }
  }

  static Future<bool> addToCart(
    String productId, {
    int quantity = 1,
    String selectedSize = 'M',
    String selectedColor = 'No Color',
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      // Get or create cart
      final cartId = await getOrCreateCart();
      if (cartId == null) return false;

      // Check if item already exists in cart
      final existingItem =
          await _supabase.from('cart_items').select().match({
            'cart_id': cartId,
            'product_id': productId,
            'selected_size': selectedSize,
            'selected_color': selectedColor,
          }).maybeSingle();

      if (existingItem != null) {
        // Update quantity if item exists
        await _supabase
            .from('cart_items')
            .update({'quantity': existingItem['quantity'] + quantity})
            .match({
              'cart_id': cartId,
              'product_id': productId,
              'selected_size': selectedSize,
              'selected_color': selectedColor,
            });
      } else {
        // Add new item if it doesn't exist
        await _supabase.from('cart_items').insert({
          'cart_id': cartId,
          'product_id': productId,
          'quantity': quantity,
          'selected_size': selectedSize,
          'selected_color': selectedColor,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  static Future<int> getCartItemCount() async {
    try {
      final cartId = await getOrCreateCart();
      if (cartId == null) return 0;

      final response = await _supabase
          .from('cart_items')
          .select('quantity')
          .eq('cart_id', cartId);

      if (response == null) return 0;

      return response.fold<int>(
        0,
        (sum, item) => sum + (item['quantity'] as int? ?? 0),
      );
    } catch (e) {
      print('Error getting cart count: $e');
      return 0;
    }
  }
}
