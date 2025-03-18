import 'package:flutter/material.dart';

class TopButtonsComponent extends StatelessWidget {
  const TopButtonsComponent({Key? key}) : super(key: key);

  void _handleSearch(BuildContext context) {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Search feature coming soon!')),
    );
  }

  void _handleRecommendations(BuildContext context) {
    // TODO: Implement recommendations functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recommendations feature coming soon!')),
    );
  }

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
            onTap: () => _handleSearch(context),
            child: Container(
              width: 30,
              height: 29,
              child: Image.asset(
                'assets/images/feed/search.png',
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Recommendations Button
          InkWell(
            onTap: () => _handleRecommendations(context),
            child: Container(
              width: 30,
              height: 30,
              child: Image.asset(
                'assets/images/feed/for-icon.png',
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}