import 'package:flutter/material.dart';

class TopButtonsComponent extends StatelessWidget {
  const TopButtonsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Removed fixed width/height constraints
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Button
          InkWell(
            onTap: () {
              // Handle search tap
            },
            child: SizedBox(
              width: 30,
              height: 29,
              child: Image.asset('assets/images/feed/search.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),
          // Recommendations Button
          InkWell(
            onTap: () {
              // Handle recommendations tap
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/feed/for-icon.png', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}