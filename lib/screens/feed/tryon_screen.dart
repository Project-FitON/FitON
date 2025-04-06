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

  late final List<Widget> screens;

  TryOnScreen({super.key, this.preloadedPlaceholderUrl});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  List<String> tryonImageUrls = [];
  List<String> buyerImageUrls = [];
  List<String> buyerImageIds = [];
  bool isLoading = true;
  int BuyerImageCurrentIndex = 0;
  int TryOnImageCurrentIndex = 0;
  final PageController _pageController = PageController();

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

    // Add the placeholder URL to the list
    if (widget.preloadedPlaceholderUrl != null) {
      tryonImageUrls.add(widget.preloadedPlaceholderUrl!);
    }

    print("Initial tryonImageUrls: $tryonImageUrls");

    // Delay fetching and generating images to ensure the placeholder is shown first
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500)); // Delay to show placeholder
      await _fetchUserUploadedPhotos(); // Fetch user-uploaded photos
      await _generateTryonImage(); // Generate the try-on image
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
    String placeholderUrl = widget.preloadedPlaceholderUrl ?? '';

    // Add the placeholder image only if it's not already in the list
    if (!tryonImageUrls.contains(placeholderUrl)) {
      if (mounted) {
        setState(() {
          tryonImageUrls.insert(0, placeholderUrl); // Ensure placeholder is the first item
        });
      }
    }

    String? generatedUrl = await processFitOnRequest(buyer_id, product_id, dependent_id);
    if (generatedUrl != null) {
      await precacheImage(CachedNetworkImageProvider(generatedUrl), context);
      if (mounted) {
        setState(() {
          tryonImageUrls[0] = generatedUrl; // Replace placeholder with the generated image
        });
      }
    }

    // Preload all try-on images
    for (String url in tryonImageUrls) {
      await precacheImage(CachedNetworkImageProvider(url), context);
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
    if (BuyerImageCurrentIndex >= buyerImageIds.length) return;

    try {
      final response = await supabase
          .from('tryons')
          .select('generated_tryons')
          .eq('input_photo_id', buyerImageIds[BuyerImageCurrentIndex])
          .single();

      if (response['generated_tryons'] != null) {
        List<String> relatedTryonImages = List<String>.from(response['generated_tryons']);
        setState(() {
          // Ensure the current buyer image remains the first URL
          tryonImageUrls = [
            buyerImageUrls[BuyerImageCurrentIndex], // Current buyer image
            ...relatedTryonImages, // Old try-on images
          ];
        });

        // Preload all try-on images
        for (String url in tryonImageUrls) {
          await precacheImage(CachedNetworkImageProvider(url), context);
        }
      } else {
        print("No old try-on images found for buyerImageId: ${buyerImageIds[BuyerImageCurrentIndex]}");
        setState(() {
          // Keep only the current buyer image if no old try-on images are found
          tryonImageUrls = [buyerImageUrls[BuyerImageCurrentIndex]];
        });
      }
    } catch (e) {
      print("Error fetching old try-on images: $e");
      setState(() {
        // Keep only the current buyer image on error
        tryonImageUrls = [buyerImageUrls[BuyerImageCurrentIndex]];
      });
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
        setState(() {
          buyerImageUrls = List<String>.from(response.map((photo) => photo['photo_url']));
          buyerImageIds = List<String>.from(response.map((photo) => photo['photo_id']));
        });

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
    setState(() {
      isLoading = true;
    });

    // Start the loading phases
    _startLoadingPhases();

    // Ensure the first URL is the current buyer image or placeholder
    if (tryonImageUrls.isEmpty || tryonImageUrls.first != buyerImageUrls[BuyerImageCurrentIndex]) {
      setState(() {
        if (tryonImageUrls.isNotEmpty) {
          tryonImageUrls[0] = buyerImageUrls[BuyerImageCurrentIndex];
        } else {
          tryonImageUrls.insert(0, buyerImageUrls[BuyerImageCurrentIndex]);
        }
      });
    }

    print("tryonImageUrls before generating: $tryonImageUrls");

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
          // Replace the placeholder with the generated image
          tryonImageUrls[0] = generatedUrl;
        });
      }
    }

    print("tryonImageUrls after generating: $tryonImageUrls");

    setState(() {
      isLoading = false;
    });

    await _fetchOldTryonImages(); // Fetch old try-on images again
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
            itemCount: buyerImageUrls.length,
            onPageChanged: (index) async {
              setState(() {
                BuyerImageCurrentIndex = index;
              });
              // Pre-load the next buyer image if it exists
              if (index + 1 < buyerImageUrls.length) {
                precacheImage(CachedNetworkImageProvider(buyerImageUrls[index + 1]), context);
              }
              await _generateTryonImageForCurrentImage();
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tryonImageUrls.length,
                    onPageChanged: (hIndex) {
                      setState(() {
                        TryOnImageCurrentIndex = hIndex;
                      });
                    },
                    itemBuilder: (context, index) {
                      if (tryonImageUrls.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return _buildTryOnImage(index);
                    },
                  ),
                ],
              );
            },
          ),

          // Top Overlay
          Positioned(top: 0, left: 0, right: 0, child: _buildStaticTopOverlay()),

          // Bottom Overlay
          Positioned(bottom: 0, left: 0, right: 0, child: _buildStaticBottomOverlay()),

          // Loading Overlay
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // Try-on image builder
  Widget _buildTryOnImage(int index) {
    return Stack(
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: tryonImageUrls[index],
            fit: BoxFit.scaleDown,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        // Top Overlay
        Positioned(top: 0, left: 0, right: 0, child: _buildTopOverlay()),
        // Bottom Overlay
        Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomOverlay()),
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

  // Helper method to build static top overlay
  Widget _buildStaticTopOverlay() {
    return Container(
      height: 242,
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