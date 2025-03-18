import 'package:fiton/screens/cart/cart_screen.dart';  // Import CartScreen
import 'package:fiton/screens/fashee/fashee_screen.dart';  // This imports FasheeHomePage
import 'package:fiton/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:fiton/screens/account/account_screen.dart';

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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => FeedScreen()),
                  (route) => false,
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => CartScreen()),
                  (route) => false,
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => FasheeScreen()),
                  (route) => false,
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                  (route) => false,
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
