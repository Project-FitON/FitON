import 'package:fiton/screens/cart/cart_screen.dart'; // Import CartScreen
import 'package:flutter/material.dart';
import 'package:fiton/screens/account/account_screen.dart';
import 'package:fiton/services/navigation_service.dart';
import 'feed_screen.dart';
import 'package:fiton/screens/fashee/fashee_screen.dart';  // This imports FasheeHomePage

class NavScreen extends StatelessWidget {
  final String currentRoute;
  
  const NavScreen({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white, // BottomAppBar with white background
      elevation: 10.0, // Set the elevation to create a shadow effect
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              label: 'Feed',
              isSelected: currentRoute == NavigationService.feedRoute,
              onTap: () => navigationService.navigateToReplacement(NavigationService.feedRoute),
            ),
            _buildNavItem(
              icon: Icons.shopping_cart_outlined,
              label: 'Cart',
              isSelected: currentRoute == NavigationService.cartRoute,
              onTap: () => navigationService.navigateToReplacement(NavigationService.cartRoute),
            ),
            IconButton(
              onPressed: () {
                // Action for add button
              },
              icon: Icon(Icons.add_circle_outline, size: 45, color: Colors.black),
            ),
            _buildNavItem(
              icon: Icons.message_outlined,
              label: 'Fashee',
              isSelected: currentRoute == NavigationService.fasheeRoute,
              onTap: () => navigationService.navigateToReplacement(NavigationService.fasheeRoute),
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isSelected: currentRoute == NavigationService.profileRoute,
              onTap: () => navigationService.navigateToReplacement(NavigationService.profileRoute),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? Colors.purple[900] : Colors.black;
    
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
