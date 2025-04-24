import 'package:flutter/material.dart';

class TryOnRightBottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Size Check Button
          InkWell(
            onTap: () {
              print('Size Check Button Pressed');
            },
            child: Container(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/feed/size-cha.png', fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 10),

          // More Options Button
          InkWell(
            onTap: () {
              print('More Options Button Pressed');
            },
            child: Container(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/feed/more.png', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
} 