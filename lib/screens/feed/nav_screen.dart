import 'dart:ui';

import 'package:flutter/material.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.shopping_cart, 1),
                  SizedBox(width: 60), // Space for center button
                  _buildNavItem(Icons.notifications, 3),
                  _buildNavItem(Icons.account_circle, 4),
                ],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 30,
                bottom: 25,
                child: FloatingActionButton(
                  onPressed: () => _onItemTapped(2),
                  backgroundColor: _selectedIndex == 2
                      ? Colors.blueAccent
                      : Colors.white,
                  elevation: 4,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      Icons.add,
                      color: _selectedIndex == 2 ? Colors.white : Colors.black,
                      size: 32,
                      key: ValueKey<int>(_selectedIndex),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.8),
          size: 30,
        ),
      ),
    );
  }
}