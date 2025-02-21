import 'package:flutter/material.dart';

class RightBottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
