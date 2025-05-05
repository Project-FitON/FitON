import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

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
    super.key,
    required this.reviewId,
    required this.commenterName,
    required this.comment,
    required this.likes,
    required this.rating, // Ensure rating is passed as double
    this.starImages = const [
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
    ],
    this.profileImage = 'assets/images/feed/commente.jpg',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 180, maxHeight: 100),
        padding: EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Rating stars
                Row(
                  children:
                      starImages
                          .map(
                            (star) => Image.asset(star, width: 10, height: 10),
                          )
                          .toList(),
                ),
                const SizedBox(width: 4),
                // Rating Text next to stars wrapped in Expanded widget to prevent overflow
                Expanded(
                  // Wrap rating text in Expanded
                  child: Text(
                    rating.toStringAsFixed(
                      1,
                    ), // Display the rating with one decimal
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow:
                        TextOverflow
                            .ellipsis, // Ensure the text doesn't overflow
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                profileImage.startsWith('assets/')
                                    ? AssetImage(profileImage)
                                    : CachedNetworkImageProvider(
                                          profileImage,
                                          errorListener: (error) {
                                            print(
                                              'Error loading profile image: $error',
                                            );
                                          },
                                        )
                                        as ImageProvider,
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              print('Error loading profile image: $exception');
                            },
                          ),
                        ),
                        child:
                            profileImage.startsWith('assets/')
                                ? null
                                : CachedNetworkImage(
                                  imageUrl: profileImage,
                                  imageBuilder:
                                      (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  placeholder:
                                      (context, url) =>
                                          const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/images/feed/commente.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        // Wrap the comment text in Expanded to avoid overflow
                        child: Text(
                          comment,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
