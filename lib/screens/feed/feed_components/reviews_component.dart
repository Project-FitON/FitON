import 'package:flutter/material.dart';
import 'dart:ui';

class ReviewsComponent extends StatelessWidget {
  final String commenterName;
  final String comment;
  final String commentCount;
  final List<String> starImages;
  final String profileImage;

  const ReviewsComponent({
    Key? key,
    this.commenterName = 'Hasitha Nadun 24',
    this.comment = 'Highly Recommended!',
    this.commentCount = '1.3K',
    this.starImages = const [
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
      'assets/images/feed/star.png',
    ],
    this.profileImage = 'assets/images/feed/commente.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 210, maxHeight: 110),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with rating and comment count
          Row(
            children: [
              // Rating stars
              Row(
                children: starImages.map((star) => Image.asset(star,width: 12,height: 12)).toList(),
              ),
              const SizedBox(width: 5),
              // Comment count
              Text(
                commentCount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Comment Box
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Slightly more opaque for better glass effect
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipRRect( // Needed to clip the blur effect within rounded corners
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14), // Blur intensity
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    // Commenter profile image
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(profileImage), // Fixed AssetImage usage
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
          )
        ],
      ),
    );
  }
}

