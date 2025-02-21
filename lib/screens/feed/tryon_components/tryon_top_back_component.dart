import 'package:flutter/material.dart';

class TryOnTopBackToShoppingComponent extends StatelessWidget {
  const TryOnTopBackToShoppingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/images/feed/back.png'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
