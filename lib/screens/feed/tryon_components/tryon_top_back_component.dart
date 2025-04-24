import 'package:flutter/material.dart';

class TryOnTopBackToShoppingComponent extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onBackToShopping; // Add callback for back action

  const TryOnTopBackToShoppingComponent({
    super.key,
    this.width = 75,
    this.height = 77,
    required this.onBackToShopping, // Require the callback
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
              onTap: onBackToShopping, // Trigger the callback
              borderRadius: BorderRadius.circular(12),
              highlightColor: Colors.white.withOpacity(0.3),
              splashColor: Colors.white.withOpacity(0.5),
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