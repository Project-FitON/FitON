import 'package:flutter/material.dart';

class TryOnTopBackToShoppingComponent extends StatelessWidget {
  final double width;
  final double height;

  const TryOnTopBackToShoppingComponent({
    Key? key,
    this.width = 75,
    this.height = 77,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back To Shopping Button
          GestureDetector(
            onTap: () {
                Navigator.pop(context); // Goes back to the previous screen
            },
            child: Container(
              width: 30,
              height: 29,
              child: Image.asset('assets/images/feed/back.png',fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}

