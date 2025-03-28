import 'package:flutter/material.dart';

class TryOnTopBackToShoppingComponent extends StatelessWidget {
  final double width;
  final double height;

  const TryOnTopBackToShoppingComponent({
    super.key,
    this.width = 75,
    this.height = 77,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back To Shopping Button with expanded touch area and custom animation
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // Goes back to the previous screen
              },
              borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
              highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
              splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
              child: SizedBox(
                width: 30,
                height: 29,
                child: Image.asset(
                  'assets/images/feed/back.png',
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