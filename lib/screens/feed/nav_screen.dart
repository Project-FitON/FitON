import 'package:fiton/screens/cart/cart_screen.dart'; // Import CartScreen
import 'package:flutter/material.dart';
import 'package:fiton/screens/account/account_screen.dart';
import 'feed_screen.dart';
import 'package:fiton/screens/fashee/fashee_screen.dart';
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedScreen()), // Navigate to FeedScreen (example)
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.home_outlined, size: 22, color: Colors.black),
                  Text('Feed', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()), // Navigate to CartScreen
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.black),
                  Text('Cart', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Action for add button
              },
              icon: Icon(Icons.add_circle_outline, size: 45, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FasheeScreen()), // Navigate to FasheeScreen (example)
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.message_outlined, size: 22, color: Colors.black),
                  Text('Fashee', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()), // Navigate to ProfileScreen (example)
                );
              },
              icon: Column(
                children: [
                  Icon(Icons.person_outline, size: 22, color: Colors.black),
                  Text('Profile', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
