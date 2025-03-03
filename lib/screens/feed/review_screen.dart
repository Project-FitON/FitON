import 'package:flutter/material.dart';
import 'dart:ui';
import 'feed_components/favourite_component.dart';

class ReviewsComponent extends StatelessWidget {
  final String reviewId; // Required to connect with Supabase
  final String commenterName;
  final String comment;
  final int likes; // Changed type to int for consistency
  final List<String> starImages;
  final String profileImage;
  final VoidCallback onTap;

  const ReviewsComponent({
    Key? key,
    required this.reviewId, // Now required to link to Supabase
    this.commenterName = 'Hasitha Nadun 24',
    this.comment = 'Highly Recommended!',
    this.likes = 1300, // Default likes count
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
        constraints: BoxConstraints(maxWidth: 210, maxHeight: 140), // Increased height
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with rating, likes, and FavouriteComponent
            Row(
              children: [
                // Rating stars
                Row(
                  children: starImages
                      .map((star) => Image.asset(star, width: 12, height: 12))
                      .toList(),
                ),
                const SizedBox(width: 5),

                // Likes count + FavouriteComponent
                FavouriteComponent(
                  reviewId: reviewId,
                  initialFavoriteCount: likes, // Dynamic likes count
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Comment Box
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

                      // Profile Image
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

                      // Comment content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            commenterName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            comment,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
