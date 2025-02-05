import 'package:flutter/material.dart';

class RightBottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
        children: [
          // Green Tick Button
          Container(
            width: 30,
            height: 30,
            child: Image.asset('assets/images/feed/size-cha.png',fit: BoxFit.contain),
          ),
          SizedBox(height: 10), // Spacing between buttons
          // Three Dots Button
          Container(
            width: 30,
            height: 30,
            child: Image.asset('assets/images/feed/more.png',fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
