import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _orders = [];
  String? _error;
  String? _debugInfo;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _debugInfo = 'Starting to load orders...';
      });

      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      setState(() {
        _debugInfo = 'User authenticated with ID: ${user.id}';
      });

      final orders = await _orderService.getUserOrders(user.id);

      setState(() {
        _debugInfo =
            'Orders fetched: ${orders.length}\nFirst order: ${orders.isNotEmpty ? orders.first : 'No orders'}';
      });

      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load orders: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (_debugInfo != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _debugInfo!,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            if (_debugInfo != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _debugInfo!,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadOrders, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No orders found', style: TextStyle(fontSize: 16)),
            if (_debugInfo != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _debugInfo!,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
              child: const Text('Refresh'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = _supabase.auth.currentUser;
                  if (user == null) {
                    throw Exception('User not authenticated');
                  }

                  setState(() {
                    _isLoading = true;
                    _debugInfo = 'Creating test order...';
                  });

                  await _orderService.createTestOrder(user.id);
                  await _loadOrders();
                } catch (e) {
                  setState(() {
                    _error = 'Failed to create test order: $e';
                    _isLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Create Test Order'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final orderItems = List<Map<String, dynamic>>.from(
            order['order_items'] ?? [],
          );
          final shopName = order['shop']?['shop_name'] ?? 'Unknown Shop';
          final status = order['status'] ?? 'Unknown';
          final statusColor = _orderService.getOrderStatusColor(status);
          final totalPrice = order['total_price']?.toDouble() ?? 0.0;
          final createdAt = DateTime.parse(order['created_at']);

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shopName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(statusColor.substring(1), radix: 16) |
                                0xFF000000,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: Color(
                              int.parse(statusColor.substring(1), radix: 16) |
                                  0xFF000000,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...orderItems.map((item) {
                    final product = item['product'];
                    final quantity = item['quantity'] ?? 1;
                    final productName = product?['name'] ?? 'Unknown Product';
                    final productPrice = product?['price']?.toDouble() ?? 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  product?['images']?[0] ??
                                      'https://placeholder.com/60x60',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${quantity}x \$${productPrice.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(quantity * productPrice).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A0933),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ordered on ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
