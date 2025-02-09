import 'package:flutter/material.dart';
import 'tryon_components/tryon_top_download_component.dart';
import 'tryon_components/tryon_top_back_component.dart';
import 'tryon_components/tryon_main_buttons_component.dart';
import 'feed_components/navigation_component.dart';
import 'tryon_components/right_bottom_buttons.dart'; // Ensure this file exists

class TryOnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset('assets/images/feed/5-1.jpg', fit: BoxFit.cover),
              ),

              // Top Overlay (Back & Download Buttons)
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
                        Colors.black.withOpacity(1),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 8),
                        child: TryOnTopBackToShoppingComponent(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, right: 8),
                        child: TryOnTopDownloadComponent(),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Overlay (Main Buttons & Navigation)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: RightBottomButtons(), // Ensure this widget exists
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
