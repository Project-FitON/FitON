import 'package:flutter/material.dart';

class MainButtonsComponent extends StatelessWidget {
  final String orderCount;

  const MainButtonsComponent({
    Key? key,
    this.orderCount = '34K',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset('assets/images/feed/share.png'),
              onPressed: () {
                print("Share button clicked!");
              },
            ),
            SizedBox(width: 150),
            IconButton(
              icon: Image.asset('assets/images/feed/cart.png'),
              onPressed: () {
                print("Cart button clicked!");
              },
            ),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Image.asset('assets/images/feed/buy-now.png'),
              onPressed: () {
                print("Buy Now button clicked!");
              },
            ),
            Transform.translate(
              offset: Offset(0, 33),
              child: Text(
                '$orderCount',
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
