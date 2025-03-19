import 'package:flutter/material.dart';
import 'package:fiton/screens/feed/tryon_components/tryon_top_back_component.dart';  // Use this import for the Back Component
import 'package:fiton/screens/feed/tryon_components/tryon_top_download_component.dart'; // Import for the Download Component
// Import for Main Buttons Component
import 'package:fiton/screens/feed/tryon_components/right_bottom_buttons.dart'; // Ensure this file exists
import 'package:fiton/screens/feed/feed_components/navigation_component.dart';

import 'feed_components/main_buttons_component.dart';
import 'feed_components/more_details_component.dart'; // Import Navigation Component
import 'package:fiton/screens/add/add_dependents_screen.dart';
import 'package:fiton/models/human_sketch.dart'; // Import our HumanSketchWidget

class TryOnScreen extends StatefulWidget {
  final String shopId;
  final String productId;
  final double price;

  const TryOnScreen({
    Key? key,
    required this.shopId,
    required this.productId,
    required this.price,
  }) : super(key: key);

  @override
  _TryOnScreenState createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _showDependentsScreen = true; // Start with dependent screen showing

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    // Automatically show the dependents screen when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeDependentsScreen() {
    setState(() {
      _showDependentsScreen = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            // Main TryOn Content
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // Human Sketch Background
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: HumanSketchWidget(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.black54,
                          strokeWidth: 3.0,
                        ),
                      ),
                    ),
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
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.3),
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
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.0),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: MainButtonsComponent(
                              shopId: widget.shopId,
                              productId: widget.productId,
                              price: widget.price,
                              onFollowSuccess: () {},
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: RightBottomButtons(),
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

            // Sliding Dependents Screen
            if (_showDependentsScreen)
              Positioned.fill(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header with close button
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B0331),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add Person',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: _closeDependentsScreen,
                              ),
                            ],
                          ),
                        ),
                        // Add dependent screen takes the rest of the space
                        Expanded(
                          child: AddDependentsScreen(),
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
