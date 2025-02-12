import 'package:flutter/material.dart';

class TryOnMainButtonsComponent extends StatelessWidget {
  final String orderCount;

  const TryOnMainButtonsComponent({
    Key? key,
    this.orderCount = '34K',
  }) : super(key: key);

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
              // Share button
              Container(
                width: 25,
                height: 25,
                child: Image.asset('assets/images/feed/share.png',fit: BoxFit.contain),
              ),
              SizedBox(width: 150),
              // Cart button
              Container(
                width: 25,
                height: 25,
                child: Image.asset('assets/images/feed/cart.png',fit: BoxFit.contain),
              ),
            ],
          ),
        ),

        Stack(
          alignment: Alignment.center,
          children: [
            // Button at the bottom
            Container(
              width: 48,
              height: 48,
              child: Image.asset('assets/images/feed/buy-now.png',fit: BoxFit.contain),
            ),
            // Order count text, shifted down by 33 pixels
            Transform.translate(
              offset: Offset(0, 33), // Moves the text downwards
              child: Text(
                '$orderCount', // Ensure orderCount is a string
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