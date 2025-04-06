import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/fiton_api.dart';
import 'tryon_components/tryon_top_download_component.dart';
import 'tryon_components/tryon_top_back_component.dart';
import 'tryon_components/tryon_main_buttons_component.dart';
import 'tryon_components/tryon_more_details_component.dart';
import 'feed_components/navigation_component.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

final String buyer_id = "009f5ebe-681a-4f2a-a25a-619362b4c606";
final String product_id = "c262374a-9275-4274-8f1f-672a271c7bcb";
final String? dependent_id = null;

// Method to process the FitOn request
class TryOnScreen extends StatefulWidget {
  final String? preloadedPlaceholderUrl;
  final PageController pageController; // Add PageController parameter

  late final List<Widget> screens;

  TryOnScreen({super.key, this.preloadedPlaceholderUrl, required this.pageController});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  List<String> previousScreenImages = [];
  List<String> currentScreenImages = [];
  List<String> nextScreenImages = [];
  List<String> buyerImageUrls = [];
  List<String> buyerImageIds = [];
  bool isLoading = false;
  int BuyerImageCurrentIndex = 0;
  int TryOnImageCurrentIndex = 0;
  final PageController _pageController = PageController();
  final PageController _horizontalPageController = PageController(); // Add a new PageController for horizontal scrolling

  final supabase = SupabaseClient(
    "https://oetruvmloogtbbrdjeyc.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o", // anon key
  );

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

    // Add the placeholder URL to the current screen images
    if (widget.preloadedPlaceholderUrl != null) {
      if (mounted) {
        setState(() {
          currentScreenImages.add(widget.preloadedPlaceholderUrl!);
        });
      }
      print("preloadedPlaceholderUrl added to currentScreenImages: $currentScreenImages");
    } else {
      print("preloadedPlaceholderUrl is null");
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500)); // Delay to show placeholder
      await _fetchUserUploadedPhotos(); // Fetch user-uploaded photos
      await _updateScreenImages(); // Update screen images
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

  // Method to fetch old try-on images
  Future<void> _fetchOldTryonImages() async {
    if (BuyerImageCurrentIndex >= buyerImageIds.length) return;

    try {
      final response = await supabase
          .from('tryons')
          .select('generated_tryons')
          .eq('input_photo_id', buyerImageIds[BuyerImageCurrentIndex])
          .single();

      if (response['generated_tryons'] != null) {
        List<String> relatedTryonImages = List<String>.from(response['generated_tryons']);
        if (mounted) {
          setState(() {
            // Ensure the current buyer image remains the first URL
            currentScreenImages = [
              buyerImageUrls[BuyerImageCurrentIndex], // Current buyer image
              ...relatedTryonImages, // Old try-on images
            ];
          });
        }

        // Preload all try-on images
        for (String url in currentScreenImages) {
          await precacheImage(CachedNetworkImageProvider(url), context);
        }
      } else {
        print("No old try-on images found for buyerImageId: ${buyerImageIds[BuyerImageCurrentIndex]}");
        if (mounted) {
          setState(() {
            // Keep only the current buyer image if no old try-on images are found
            currentScreenImages = [buyerImageUrls[BuyerImageCurrentIndex]];
          });
        }
      }
    } catch (e) {
      print("Error fetching old try-on images: $e");
      if (mounted) {
        setState(() {
          // Keep only the current buyer image on error
          currentScreenImages = [buyerImageUrls[BuyerImageCurrentIndex]];
        });
      }
    }
  }

  // Method to fetch old try-on images for a specific index
  Future<void> _fetchOldTryonImagesForIndex(int index, List<String> targetList) async {
    try {
      final response = await supabase
          .from('tryons')
          .select('generated_tryons')
          .eq('input_photo_id', buyerImageIds[index])
          .single();

      if (response['generated_tryons'] != null) {
        List<String> relatedTryonImages = List<String>.from(response['generated_tryons']);
        targetList.addAll(relatedTryonImages);

        // Preload all images in the target list
        for (String url in targetList) {
          await precacheImage(CachedNetworkImageProvider(url), context);
        }
      }
    } catch (e) {
      print("Error fetching old try-on images for index $index: $e");
    }
  }

  // Method to fetch user uploaded photos
  Future<void> _fetchUserUploadedPhotos() async {
    try {
      final response = await supabase
          .from('photos')
          .select('photo_url, photo_id')
          .eq('buyer_id', buyer_id)
          .order('created_at', ascending: true);

      if (response.isNotEmpty) {
        if (mounted) {
          setState(() {
            buyerImageUrls = List<String>.from(response.map((photo) => photo['photo_url']));
            buyerImageIds = List<String>.from(response.map((photo) => photo['photo_id']));
          });
        }

        // Preload all buyer images sequentially
        for (String url in buyerImageUrls) {
          await precacheImage(CachedNetworkImageProvider(url), context);
        }

        print("All buyer images preloaded successfully.");
      } else {
        print("No photos found for buyer_id: $buyer_id");
      }
    } catch (e) {
      print("Error fetching user uploaded photos: $e");
    }
  }

  // Generate try-on image for the current buyer image
  Future<void> _generateTryonImageForCurrentImage() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    // Start the loading phases
    _startLoadingPhases();

    // Ensure the first URL is the current buyer image or placeholder
    if (currentScreenImages.isEmpty || currentScreenImages.first != buyerImageUrls[BuyerImageCurrentIndex]) {
      if (mounted) {
        setState(() {
          if (currentScreenImages.isNotEmpty) {
            currentScreenImages[0] = buyerImageUrls[BuyerImageCurrentIndex];
          } else {
            currentScreenImages.insert(0, buyerImageUrls[BuyerImageCurrentIndex]);
          }
        });
      }
    }

    print("currentScreenImages before generating: $currentScreenImages");

    String? generatedUrl = await processFitOnRequest(
      buyer_id,
      product_id,
      dependent_id,
      buyerImageIds[BuyerImageCurrentIndex],
      buyerImageUrls[BuyerImageCurrentIndex],
    );

    if (generatedUrl != null) {
      await precacheImage(CachedNetworkImageProvider(generatedUrl), context); // Preload the generated image
      if (mounted) {
        setState(() {
          // Insert the generated image after the current buyer image
          currentScreenImages.insert(1, generatedUrl);
        });
      }

      // Automatically swipe horizontally to the generated image
      await _horizontalPageController.animateToPage(
        1, // Index of the generated image in the horizontal PageView
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (generatedUrl == null){
      // Automatically swipe horizontally to the next image
      await _horizontalPageController.animateToPage(
        1, // Index of the generated image in the horizontal PageView
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }


    print("currentScreenImages after generating: $currentScreenImages");

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    await _fetchOldTryonImages(); // Fetch old try-on images again
  }

  // Method to update screen images
  Future<void> _updateScreenImages() async {
    if (mounted) {
      setState(() {
        currentScreenImages = [buyerImageUrls[BuyerImageCurrentIndex]];
      });
    }

    // Fetch old try-on images for the current screen
    await _fetchOldTryonImages();

    // Preload previous screen images
    if (BuyerImageCurrentIndex > 0) {
      previousScreenImages = [buyerImageUrls[BuyerImageCurrentIndex - 1]];
      await _fetchOldTryonImagesForIndex(BuyerImageCurrentIndex - 1, previousScreenImages);
    } else {
      previousScreenImages = [];
    }

    // Preload next screen images
    if (BuyerImageCurrentIndex + 1 < buyerImageUrls.length) {
      nextScreenImages = [buyerImageUrls[BuyerImageCurrentIndex + 1]];
      await _fetchOldTryonImagesForIndex(BuyerImageCurrentIndex + 1, nextScreenImages);
    } else {
      nextScreenImages = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for vertical scrolling
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: buyerImageUrls.isNotEmpty ? buyerImageUrls.length : 1,
            onPageChanged: (index) async {
              if (buyerImageUrls.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    BuyerImageCurrentIndex = index;
                  });
                }
                await _updateScreenImages();
              }
            },
            itemBuilder: (context, index) {
              List<String> imagesToShow;
              if (buyerImageUrls.isEmpty) {
                imagesToShow = currentScreenImages; // Show placeholder if no buyer images
              } else if (index == BuyerImageCurrentIndex - 1) {
                imagesToShow = previousScreenImages;
              } else if (index == BuyerImageCurrentIndex) {
                imagesToShow = currentScreenImages;
              } else if (index == BuyerImageCurrentIndex + 1) {
                imagesToShow = nextScreenImages;
              } else {
                imagesToShow = [];
              }

              return GestureDetector(
                onDoubleTap: () async {
                  if (mounted) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  _startLoadingPhases();
                  await _generateTryonImageForCurrentImage();
                },
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _horizontalPageController, // Use the horizontal PageController
                      scrollDirection: Axis.horizontal,
                      itemCount: imagesToShow.length,
                      itemBuilder: (context, index) {
                        if (imagesToShow.isEmpty) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Stack(
                          children: [
                            _buildTryOnImage(imagesToShow[index]),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          // Back Overlay
          Positioned(top: 0, left: 0, right: 0, child: _buildBackOverlay()),

          // Bottom Overlay
          Positioned(bottom: 0, left: 0, right: 0, child: _buildStaticBottomOverlay()),

          // Loading Overlay
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // Try-on image builder
  Widget _buildTryOnImage(String imageUrl) {
    return Stack(
      children: [
        SizedBox.expand( // Ensure the image fills the available space
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.scaleDown, // Ensure the image covers the full screen
            placeholder: (context, url) => Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        // Top Overlay
        Positioned(top: 0, left: 0, right: 0, child: _buildTopOverlay()),
        // Bottom Overlay
        Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomOverlay()),
        // Bottom Overlay
        Positioned(top: 0, left: 0, right: 0, child: _buildDownloadOverlay(imageUrl)),
      ],
    );
  }

  // Helper method to build top overlay
  Widget _buildTopOverlay() {
    return Container(
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
    );
  }

  // Helper method to build Back overlay
  Widget _buildBackOverlay() {
    return Container(
      height: 242,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: TryOnTopBackToShoppingComponent(
                onBackToShopping: () {
                  widget.pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ); // Swipe back to the feed screen
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build Download overlay
  Widget _buildDownloadOverlay(String imageUrl) {
    return Container(
      height: 242,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: TryOnTopDownloadComponent(
                currentImageUrl: currentScreenImages.isNotEmpty
                    ? imageUrl // Pass the first image in the current screen
                    : '', // Fallback to an empty string if no image is available
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build bottom overlay
  Widget _buildBottomOverlay() {
    return Container(
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
    );
  }

  // Helper method to build static bottom overlay
  Widget _buildStaticBottomOverlay() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: NavigationComponent(),
          ),
        ],
      ),
    );
  }

  // Helper method to build loading overlay
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _getLoadingPhaseMessage(),
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
    );
  }
}