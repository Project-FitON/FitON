import 'package:flutter/material.dart';

class TopButtonsComponent extends StatelessWidget {
  final double width;
  final double height;

  const TopButtonsComponent({
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Button
          InkWell(
            onTap: () {
              // Handle search tap
            },
            child: Container(
              width: 30,
              height: 29,
              child: Image.asset('assets/images/feed/search.png',fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 10),
          // Recommendations Button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  // Handle recommendations tap
                },
                child: Container(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/feed/for-icon.png',fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 14),
              Transform.rotate(
                angle: 1.5708, // Rotates the text 90 degrees counterclockwise
                child: Text(
                  'For Me',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

