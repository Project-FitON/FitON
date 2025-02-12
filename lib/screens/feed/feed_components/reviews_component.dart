import 'package:flutter/material.dart';
import 'dart:ui';

class ReviewsComponent extends StatelessWidget {
  final String reviewId;
  final String commenterName;
  final String comment;
  final int likes;
  final double rating; // Changed to double to handle rating precision
  final List<String> starImages;
  final String profileImage;
  final VoidCallback onTap;

  const ReviewsComponent({
    Key? key,
    required this.reviewId,
    required this.commenterName,
    required this.comment,
    required this.likes,
    required this.rating,  // Ensure rating is passed as double
    this.starImages = const [
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
    ],
    this.profileImage = 'assets/images/feed/commente.jpg',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 210, maxHeight: 120),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Rating stars
                Row(
                  children: starImages.map((star) => Image.asset(star, width: 12, height: 12)).toList(),
                ),
                const SizedBox(width: 5),
                // Rating Text next to stars wrapped in Expanded widget to prevent overflow
                Expanded( // Wrap rating text in Expanded
                  child: Text(
                    rating.toStringAsFixed(1), // Display the rating with one decimal
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis, // Ensure the text doesn't overflow
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(profileImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded( // Wrap the comment text in Expanded to avoid overflow
                        child: Text(
                          comment,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
