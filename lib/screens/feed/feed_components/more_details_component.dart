import 'package:flutter/material.dart';

class RightBottomButtons extends StatelessWidget {
  const RightBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
        children: [
          // Green Tick Button
          InkWell(
            onTap: () {
              // Handle the tap event for Green Tick Button
              print('Green Tick Button Pressed');
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/feed/size-cha.png', fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 10), // Spacing between buttons

          // Three Dots Button
          InkWell(
            onTap: () {
              // Handle the tap event for Three Dots Button
              print('Three Dots Button Pressed');
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/feed/more.png', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
