import 'package:flutter/material.dart';
import '../feed/nav_screen.dart';
import '../settings/settings_screen.dart';
import 'notifications_screen.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/order_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  bool _showOrdersScreen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  User? _currentUser;
  final UserService _userService = UserService();
  final OrderService _orderService = OrderService();
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _error;
  String? _debugInfo;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Check database structure first
      await _userService.checkBuyersTable();
      // Then load user data
      await _loadUserData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error initializing: $e')));
      }
    }
  }

  Future<void> _loadUserData() async {
    try {
      setState(() => _isLoading = true);
      final user = await _userService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading user data: $e')));
      }
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _userService.signOut();
      // Navigate to login screen or handle sign out
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleOrdersScreen() {
    setState(() {
      _showOrdersScreen = !_showOrdersScreen;
      if (_showOrdersScreen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0933), // Dark purple background
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Account Settings'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.settings),
                                    title: Text('Settings'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => SettingsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.logout),
                                    title: Text('Sign Out'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _handleSignOut();
                                    },
                                  ),
                                ],
                              ),
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // User Profile Section with actual user data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child:
                                _currentUser?.profileImageUrl != null
                                    ? ClipOval(
                                      child: Image.network(
                                        _currentUser!.profileImageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Color(0xFF1A0933),
                                                ),
                                      ),
                                    )
                                    : const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Color(0xFF1A0933),
                                    ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentUser?.name ?? 'No Name',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _currentUser?.email ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_currentUser?.planType ?? 'Free Plan'} User',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            ),

            // Main Content Area with White Background (curved container)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // Side Navigation Menu (positioned on the left, half height)
                    Positioned(
                      left: 0,
                      top: 60,
                      height: screenHeight / 2, // Half of screen height
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF1B0331),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.grid_view,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.card_giftcard,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.local_shipping_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.list_alt_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main Content
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 60,
                      ), // Offset to account for side menu
                      child: Column(
                        children: [
                          // Center Menu Bar
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // My Collection Tab
                                Row(
                                  children: [
                                    Icon(
                                      Icons.collections_outlined,
                                      color: Color(0xFF1A0933),
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'My Collection',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A0933),
                                      ),
                                    ),
                                  ],
                                ),
                                // Orders Tab (represented by truck icon as in design)
                                GestureDetector(
                                  onTap: _toggleOrdersScreen,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.local_shipping,
                                      color: Color(0xFF1A0933),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content Area with Animation
                          Expanded(
                            child: Stack(
                              children: [
                                // Collection Screen
                                Visibility(
                                  visible:
                                      !_showOrdersScreen ||
                                      _animationController.value < 1.0,
                                  child: FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 1.0,
                                      end: 0.0,
                                    ).animate(_animation),
                                    child: CollectionScreen(),
                                  ),
                                ),

                                // Orders Screen with Animation
                                Visibility(
                                  visible:
                                      _showOrdersScreen ||
                                      _animationController.value > 0.0,
                                  child: FadeTransition(
                                    opacity: _animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(_animation),
                                      child: OrdersScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavScreen(),
    );
  }
}

// Collection Screen Widget with real data
class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final OrderService _orderService = OrderService();
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _orders = [];
  String? _error;

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
      });

      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final orders = await _orderService.getUserOrders(user.id);

      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadOrders, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Orders Count Card with real count
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0933),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _orders.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'In Orders',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Grid Layout for Orders
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final orderItems = List<Map<String, dynamic>>.from(
                  order['order_items'] ?? [],
                );
                final firstItem =
                    orderItems.isNotEmpty ? orderItems.first : null;
                final product = firstItem?['product'];
                final status = order['status'] ?? 'Unknown';
                final totalPrice = order['total_price']?.toDouble() ?? 0.0;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Product Image or Placeholder
                        if (product != null &&
                            product['images'] != null &&
                            (product['images'] as List).isNotEmpty)
                          Image.network(
                            product['images'][0],
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        else
                          Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.shopping_bag,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),

                        // Gradient Overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${orderItems.length} ${orderItems.length == 1 ? 'item' : 'items'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Status Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shipped':
        return Colors.blue;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'processing':
      case 'to ship':
        return Colors.orange;
      case 'pending':
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Orders Screen Widget with real data
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
        _orders = orders;
        _isLoading = false;
      });
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'My Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A0933),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final orderItems = List<Map<String, dynamic>>.from(
                  order['order_items'] ?? [],
                );
                final firstItem =
                    orderItems.isNotEmpty ? orderItems.first : null;
                final product = firstItem?['product'];
                final status = order['status'] ?? 'Unknown';
                final totalPrice = order['total_price']?.toDouble() ?? 0.0;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Product Image or Placeholder
                        if (product != null &&
                            product['images'] != null &&
                            (product['images'] as List).isNotEmpty)
                          Image.network(
                            product['images'][0],
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        else
                          Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.shopping_bag,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        // Gradient Overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${orderItems.length} ${orderItems.length == 1 ? 'item' : 'items'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Status Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shipped':
        return Colors.blue;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'processing':
      case 'to ship':
        return Colors.orange;
      case 'pending':
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Custom widget for clothing item cards
class ClothingItemCard extends StatelessWidget {
  final Color color;

  const ClothingItemCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
                ),
              ),
              child: Icon(
                Icons.checkroom,
                size: 50,
                color: color.withOpacity(0.5),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
