import 'dart:async';

import 'package:fiton/services/placeholder_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/fiton_api.dart';
import 'tryon_components/tryon_top_download_component.dart';
import 'tryon_components/tryon_top_back_component.dart';
import 'tryon_components/tryon_main_buttons_component.dart';
import 'tryon_components/tryon_more_details_component.dart';
import 'feed_components/navigation_component.dart';
import 'package:flutter/material.dart';

final String buyer_id = "d85fc6f3-6d3a-4ee1-aa6e-d3fae8b9ec3f";
final String product_id = "c262374a-9275-4274-8f1f-672a271c7bcb";
final String? dependent_id = null;

// Method to process the FitOn request
class TryOnScreen extends StatelessWidget {
  final String? preloadedPlaceholderUrl;

  late final List<Widget> screens;

  TryOnScreen({Key? key, this.preloadedPlaceholderUrl}) : super(key: key) {
    screens = List.generate(
      10, // Number of screens to generate
      (index) => TryOnScreenContent(preloadedPlaceholderUrl: preloadedPlaceholderUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: screens.length,
            itemBuilder: (context, index) {
              return screens[index];
            },
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
                    padding: const EdgeInsets.only(top: 0),
                    child: NavigationComponent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TryOnScreenContent class
class TryOnScreenContent extends StatefulWidget {
  final String? preloadedPlaceholderUrl;

  const TryOnScreenContent({Key? key, this.preloadedPlaceholderUrl}) : super(key: key);

  @override
  _TryOnScreenContentState createState() => _TryOnScreenContentState();
}

class _TryOnScreenContentState extends State<TryOnScreenContent> {
  List<String> tryonImageUrls = [];
  bool isLoading = true;
  int currentIndex = 0;
  final PageController _pageController = PageController();

  // Add these variables
  int _loadingPhaseIndex = 0;
  final List<String> _loadingPhases = [
    "Matching Sizes...",
    "Fitting On...",
    "Almost Done. Just a few seconds...",
  ];


  @override
  void initState() {
    super.initState();

    // Use the preloaded placeholder URL if available
    if (widget.preloadedPlaceholderUrl != null) {
      tryonImageUrls.add(widget.preloadedPlaceholderUrl!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _generateTryonImage(); // Generate the try-on image
      _startLoadingPhases(); // Start the phased messages
    });
  }

  // Method to start the phased messages
  void _startLoadingPhases() {
    const List<int> phaseDurations = [3, 10]; // Durations in seconds for the first two phases
    int elapsedTime = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isLoading) {
        timer.cancel();
      } else if (mounted) {
        setState(() {
          if (elapsedTime < phaseDurations[0]) {
            _loadingPhaseIndex = 0; // "Matching Sizes..."
          } else if (elapsedTime < phaseDurations[0] + phaseDurations[1]) {
            _loadingPhaseIndex = 1; // "Fitting On..."
          } else {
            _loadingPhaseIndex = 2; // "Almost Done. Just a few seconds..."
          }
          elapsedTime++;
        });
      }
    });
  }

  // Method to get the loading phase message
  String _getLoadingPhaseMessage() {
    return _loadingPhases[_loadingPhaseIndex];
  }

  // Method to generate the try-on image
  Future<void> _generateTryonImage() async {
    String placeholderUrl = 'https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/fiton/buyer_images/buyer_1/profile_1.jpg';
    
    // Add the placeholder image only if it's not already in the list
    if (!tryonImageUrls.contains(placeholderUrl)) {
      if (mounted) {
        setState(() {
          tryonImageUrls.add(placeholderUrl); // Add placeholder image first
        });
      }
    }

    String? generatedUrl = await processFitOnRequest(buyer_id, product_id, dependent_id); // Call the API
    if (generatedUrl != null) {
      await precacheImage(NetworkImage(generatedUrl), context); // Preload the generated image
      if (mounted) {
        setState(() {
          tryonImageUrls[tryonImageUrls.length - 1] = generatedUrl; // Replace placeholder with generated image
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    await _fetchOldTryonImages();
  }

  // Method to fetch old try-on images
  Future<void> _fetchOldTryonImages() async {
    List<String>? oldTryonImages = await fetchOldTryonImages(); // Fetch old try-on images from Supabase
    if (oldTryonImages != null) {
      for (String imageUrl in oldTryonImages) {
        if (!tryonImageUrls.contains(imageUrl)) { // Ensure the image is not already in the list
          if (mounted) {
            await precacheImage(NetworkImage(imageUrl), context); // Preload the image into cache
          }
          if (mounted) {
            setState(() {
              tryonImageUrls.add(imageUrl);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal, // Horizontal swipe
          itemCount: tryonImageUrls.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
              if (index == tryonImageUrls.length - 1) {
                _fetchOldTryonImages();
              }
            });
          },
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = _pageController.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                }
                return Transform(
                  transform: Matrix4.identity()..scale(value, value),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      // Image content
                      Positioned.fill(
                        child: Image.network(
                          tryonImageUrls[index],
                          fit: BoxFit.scaleDown,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
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
                                Colors.black.withOpacity(1),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.0),
                              ],
                            ),
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
                              SizedBox(height: 75),
                            ],
                          ),
                        ),
                      ),
                      // Loading overlay
                      if (isLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Magic Wand Animation
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SpinKitPulse(
                                        color: Colors.white,
                                        size: 80.0,
                                      ),
                                      Icon(
                                        Icons.auto_awesome, // Magic wand icon
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Phased Messages
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: Text(
                                    _getLoadingPhaseMessage(), // Dynamic message based on phase
                                    key: ValueKey<int>(_loadingPhaseIndex),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Method to fetch old try-on images
Future<List<String>?> fetchOldTryonImages() async {
  final supabase = SupabaseClient(
    "https://oetruvmloogtbbrdjeyc.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o", // anon key
  );

  try {
    final response = await supabase
        .from('tryons')
        .select('generated_tryons')
        .eq('buyer_id', buyer_id)
        .single();

    if (response['generated_tryons'] != null) {
      return List<String>.from(response['generated_tryons']);
    } else {
      print("No old try-on images found: $response");
      return null;
    }
  } catch (e) {
    print("Error fetching old try-on images: $e");
    return null;
  }
}