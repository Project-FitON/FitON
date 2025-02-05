import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white, // BottomAppBar with white background
      elevation: 10.0, // Set the elevation to create a shadow effect
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Column(
                children: [
                  Icon(Icons.home_outlined, size: 22, color: Colors.black), // Icon color set to black54
                  Text('Feed', style: TextStyle(fontSize: 12, color: Colors.black)), // Text color set to black54
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Column(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.black), // Icon color set to black54
                  Text('Cart', style: TextStyle(fontSize: 12, color: Colors.black)
                  ), // Text color set to black54
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_circle_outline, size: 45, color: Colors.black), // Icon color set to black54
            ),
            IconButton(
              onPressed: () {},
              icon: Column(
                children: [
                  Icon(Icons.message_outlined, size: 22, color: Colors.black), // Icon color set to black54
                  Text('Fashee', style: TextStyle(fontSize: 12, color: Colors.black)), // Text color set to black54
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Column(
                children: [
                  Icon(Icons.person_outline, size: 22, color: Colors.black), // Icon color set to black54
                  Text('Profile', style: TextStyle(fontSize: 12, color: Colors.black)), // Text color set to black54
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
