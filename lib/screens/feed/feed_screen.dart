import 'package:fiton/screens/feed/tryon_components/tryon_main_buttons_component.dart';

import 'tryon_screen.dart';
import 'feed_components/more_details_component.dart';
import 'package:flutter/material.dart';
import 'feed_components/seller_component.dart';
import 'feed_components/top_buttons_component.dart';
import 'feed_components/favourite_component.dart';
import 'feed_components/reviews_component.dart';
import 'feed_components/product_component.dart';
import 'feed_components/navigation_component.dart';

class FeedScreen extends StatelessWidget {
  // A sample reviewId, you might get it dynamically from the data
  final String reviewId = '141634fc-53db-43c1-95e0-52ef1f8c5990';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Right Swipe → Go Back
            Navigator.pop(context);
          } else if (details.primaryVelocity! < 0) {
            // Left Swipe → Navigate to FeedScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TryOnScreen()),
            );
          }
        },
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/images/feed/recommed.jpg', fit: BoxFit.cover),
              ),
              // Top Overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 242,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(1), // Fully visible at the top
                        Colors.black.withOpacity(0.5),  // Midpoint fade
                        Colors.black.withOpacity(0.0),  // Fully transparent at the bottom
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 8),
                            child: SellerComponent(onTap: () {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 16),
                            child: FavouriteComponent(
                              reviewId: reviewId, // Pass the reviewId dynamically
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TopButtonsComponent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(1),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: MainButtonsComponent(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ReviewsComponent(onTap: () {}),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: ProductComponent(onTap: () {}),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 9),
                              child: RightBottomButtons(),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: NavigationComponent(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
