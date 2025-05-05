import 'package:flutter/material.dart';
import '../search_screen.dart';
import '../recommendations_screen.dart';

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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 30,
                height: 29,
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  'assets/images/feed/search.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Recommendations Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecommendationsScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  'assets/images/feed/for-icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
