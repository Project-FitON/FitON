import 'package:flutter/material.dart';

class TryOnTopBackToShoppingComponent extends StatelessWidget {
  const TryOnTopBackToShoppingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Navigate back
      },
      child: Image.asset('assets/images/feed/back.png', fit: BoxFit.contain),
    );
  }
}
