import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black.withOpacity(0.4),  // More transparency
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {},
            iconSize: 30.0,  // Larger icon size
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
            iconSize: 30.0,  // Larger icon size
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {},
            iconSize: 45.0,  // Larger icon size
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
            iconSize: 30.0,  // Larger icon size
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
            iconSize: 30.0,  // Larger icon size
          ),
        ],
      ),
    );
  }
}
