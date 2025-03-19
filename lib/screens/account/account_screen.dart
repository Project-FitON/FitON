import 'package:flutter/material.dart';
import '../feed/feed_components/navigation_component.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.purple[900],
      ),
      body: Stack(
        children: [
          // Main content with bottom padding for navigation
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(bottom: 60),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/feed/profile.jpg'),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Account Options
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildListTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.favorite_border,
                        title: 'Wishlist',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.location_on_outlined,
                        title: 'Shipping Addresses',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () {},
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Navigation component at the bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigationComponent(),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey[800],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.grey[800],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
