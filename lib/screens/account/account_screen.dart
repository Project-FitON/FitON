import 'package:flutter/material.dart';
import '../feed/nav_screen.dart';
import 'notifications_screen.dart';

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
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // User Profile Section with custom avatar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  // Profile Avatar - White cat avatar as shown in design
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      'assets/images/white_cat_avatar.png',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nimasha Heath',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Free Plan User',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
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

// Collection Screen Widget (existing content)
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Orders Count Card
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0933),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'In Orders',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Grid Layout for Clothing Items
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                // Orange embroidered top
                ClothingItemCard(imageUrl: 'assets/images/orange_top.png'),
                // Red casual top
                ClothingItemCard(imageUrl: 'assets/images/red_top.png'),
                // Teal satin crop top
                ClothingItemCard(imageUrl: 'assets/images/teal_top.png'),
                // Orange mini dress
                ClothingItemCard(imageUrl: 'assets/images/orange_dress.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Orders Screen Widget (similar layout but for orders)
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orders Title
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

          // Grid Layout for Orders
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                // Using the same images but with order status overlay
                OrderItemCard(
                  imageUrl: 'assets/images/orange_top.png',
                  status: 'Shipped',
                ),
                OrderItemCard(
                  imageUrl: 'assets/images/red_top.png',
                  status: 'Processing',
                ),
                OrderItemCard(
                  imageUrl: 'assets/images/teal_top.png',
                  status: 'Delivered',
                ),
                OrderItemCard(
                  imageUrl: 'assets/images/orange_dress.png',
                  status: 'Pending',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for clothing item cards
class ClothingItemCard extends StatelessWidget {
  final String imageUrl;

  const ClothingItemCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
            Image.asset(imageUrl, fit: BoxFit.cover),
            // Optional: Add a gradient overlay at the bottom for better visibility of possible text
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
                    colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
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

// Custom widget for order item cards
class OrderItemCard extends StatelessWidget {
  final String imageUrl;
  final String status;

  const OrderItemCard({super.key, required this.imageUrl, required this.status});

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
            Image.asset(imageUrl, fit: BoxFit.cover),
            // Gradient overlay
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
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
              ),
            ),
            // Status badge
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
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
  }
}
