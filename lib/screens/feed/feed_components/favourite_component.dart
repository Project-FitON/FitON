import 'package:flutter/material.dart';

class FavouriteComponent extends StatelessWidget {
  final int favoriteCount;
  
  const FavouriteComponent({
    Key? key,
    this.favoriteCount = 1100, // Default value of 1.1K
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Favourite Icon
          Container(
            width: 30,
            height: 30,
            child: Image.asset('assets/images/feed/favourit.png',fit: BoxFit.contain),
          ),
          const SizedBox(height: 0), // Adjusted spacing between icon and text
          // Favourites count
          Text(
            '${(favoriteCount / 1000).toStringAsFixed(1)}K',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
