import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUserOrders(String buyerId) async {
    try {
      // Fetch orders with product details
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items(
              *,
              product:products(*)
            ),
            shop:shops(shop_name)
          ''')
          .eq('buyer_id', buyerId)
          .order('created_at', ascending: false);

      print('Orders response: $response');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Failed to fetch orders');
    }
  }

  Future<void> createTestOrder(String buyerId) async {
    try {
      // First, create a test shop if it doesn't exist
      final shopId = const Uuid().v4();
      await _supabase.from('shops').upsert({
        'shop_id': shopId,
        'shop_name': 'Test Shop',
        'email': 'testshop@example.com',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Create a test product
      final productId = const Uuid().v4();
      await _supabase.from('products').upsert({
        'product_id': productId,
        'shop_id': shopId,
        'name': 'Test Product',
        'price': 99.99,
        'stock': 100,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Create the order
      final orderId = const Uuid().v4();
      await _supabase.from('orders').insert({
        'order_id': orderId,
        'buyer_id': buyerId,
        'shop_id': shopId,
        'status': 'Processing',
        'payment_method': 'Credit Card',
        'total_price': 99.99,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Create order items
      await _supabase.from('order_items').insert({
        'order_item_id': const Uuid().v4(),
        'order_id': orderId,
        'product_id': productId,
        'quantity': 1,
        'selected_size': 'M',
        'selected_color': 'Blue',
        'price': 99.99,
        'created_at': DateTime.now().toIso8601String(),
      });

      print('Test order created successfully');
    } catch (e) {
      print('Error creating test order: $e');
      throw Exception('Failed to create test order');
    }
  }

  String getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return '#4CAF50'; // Green
      case 'processing':
      case 'to ship':
        return '#FF9800'; // Orange
      case 'shipped':
        return '#2196F3'; // Blue
      case 'cancelled':
        return '#F44336'; // Red
      case 'unpaid':
        return '#9E9E9E'; // Grey
      default:
        return '#9E9E9E'; // Grey
    }
  }
}
