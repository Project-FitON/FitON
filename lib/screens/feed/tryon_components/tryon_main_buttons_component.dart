import 'package:flutter/material.dart';

class TryOnMainButtonsComponent extends StatelessWidget {
  final String orderCount;

  const TryOnMainButtonsComponent({
    super.key,
    this.orderCount = '34K',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Move the Row down slightly to overlap with the Stack
        Transform.translate(
          offset: Offset(0, 10), // Adjust this value to control the overlap
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Share button with expanded touch area and custom animation
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle share button tap
                    print('Share button tapped');
                  },
                  borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
                  highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
                  splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      'assets/images/feed/share.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 150),
              // Cart button with expanded touch area and custom animation
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle cart button tap
                    print('Cart button tapped');
                  },
                  borderRadius: BorderRadius.circular(12), // Rounded corners for ripple effect
                  highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
                  splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      'assets/images/feed/cart.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Stack(
          alignment: Alignment.center,
          children: [
            // Buy Now button with expanded touch area and custom animation
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle buy-now button tap
                  print('Buy Now button tapped');
                },
                borderRadius: BorderRadius.circular(24), // Rounded corners for ripple effect
                highlightColor: Colors.white.withOpacity(0.3), // Highlight color on touch
                splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.asset(
                    'assets/images/feed/buy-now.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Order count text, shifted down by 33 pixels
            Transform.translate(
              offset: Offset(0, 33), // Moves the text downwards
              child: Text(
                orderCount, // Ensure orderCount is a string
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}