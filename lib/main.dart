import 'package:fiton/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:fiton/screens/cart/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitON',
      debugShowCheckedModeBanner: false,
      home:FeedScreen(),
    );
  }
}