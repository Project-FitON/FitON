import 'package:flutter/material.dart';

class RightBottomButtons extends StatelessWidget {
  const RightBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
        children: [
          // Green Tick Button with expanded touch area and custom animation
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle the tap event for Green Tick Button
                print('Green Tick Button Pressed');
              },
              borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
              highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
              splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  'assets/images/feed/size-cha.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Spacing between buttons

          // Three Dots Button with expanded touch area and custom animation
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle the tap event for Three Dots Button
                print('Three Dots Button Pressed');
              },
              borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
              highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
              splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  'assets/images/feed/more.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}