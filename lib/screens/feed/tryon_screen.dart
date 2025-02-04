import 'tryon_components/tryon_top_download_component.dart';
import 'tryon_components/tryon_top_back_component.dart';
import 'tryon_components/tryon_main_buttons_component.dart';
import 'feed_components/more_details_component.dart';
import 'feed_components/navigation_component.dart';
import 'package:flutter/material.dart';

class TryOnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Check if the swipe was towards the right
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context); // Navigate back
          }
        },
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/images/feed/5-1.jpg',fit: BoxFit.cover),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 50, left: 8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: TryOnTopBackToShoppingComponent(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50, right: 8),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: TryOnTopDownloadComponent(),
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
                        Colors.black.withOpacity(1), // Fully visible at the top
                        Colors.black.withOpacity(0.5),  // Midpoint fade
                        Colors.black.withOpacity(0.0),  // Fully transparent at the bottom
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TryOnMainButtonsComponent(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [                 
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
