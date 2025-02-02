import 'package:flutter/material.dart';
import 'package:fiton/screens/nav/nav_screen.dart';

class TryOnScreen extends StatefulWidget {
  @override
  _TryOnScreenState createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  final List<Map<String, String>> cardData = [
    {
      'image': 'lib/cloth_1.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          iconSize: 30.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            iconSize: 30.0,
            onPressed: () {
              // Handle download action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: buildCard(cardData[0]),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.80,
            left: MediaQuery.of(context).size.width * 0.265,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildIconButton(Icons.send_rounded, () {
                  // Handle share action
                }),
                SizedBox(width: 20),
                buildIconButton(Icons.shopping_bag, () {
                  // Handle buy action
                }),
                SizedBox(width: 20),
                buildIconButton(Icons.shopping_cart, () {
                  // Handle cart action
                }),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavScreen(),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Map<String, String> card) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        card['image']!,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 32, color: Colors.white),
      onPressed: onPressed,
    );
  }
}
