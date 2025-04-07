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
import 'package:image_picker/image_picker.dart';

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
  State<TryOnScreen> createState() => TryOnScreenState();
}

class TryOnScreenState extends State<TryOnScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _imageOpacity = 1.0; // For fade-out effect

  final PageController _pageController = PageController();
  final PageController _horizontalPageController = PageController();
  final ImagePicker _imagePicker = ImagePicker();
  List<String> previousScreenImages = [];
  List<String> currentScreenImages = [];
  List<String> nextScreenImages = [];
  List<String> buyerImageUrls = [];
  List<String> buyerImageIds = [];
  int BuyerImageCurrentIndex = 0;
  int TryOnImageCurrentIndex = 0;
  String? imageDownloadUrl = null;
  double _uploadProgress = 0.0;
  String? _currentImageUrl;
  bool isLoading = false;
  bool isGeneratingTryOn = false; // New flag for try-on generation
  bool isImagesPreloaded = false; // New flag to track preloading status

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1), // Slide upwards
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Add the placeholder URL to the current screen images
    if (widget.preloadedPlaceholderUrl != null) {
      currentScreenImages.add(widget.preloadedPlaceholderUrl!);
      print("preloadedPlaceholderUrl added to currentScreenImages: $currentScreenImages");
    } else {
      print("preloadedPlaceholderUrl is null");
    }

    // Ensure placeholder URL is logged before preloading buyer images
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchUserUploadedPhotos(); // Fetch user-uploaded photos
      await _updateScreenImages(); // Update screen images
      if (mounted) {
        setState(() {
          isImagesPreloaded = true; // Mark images as preloaded
          print("All buyer images preloaded successfully.");
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to start the phased messages
  void _startLoadingPhases() {
    const List<int> phaseDurations = [3, 10]; // Durations in seconds for the first two phases
    int elapsedTime = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGeneratingTryOn) {
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

        // Preload images asynchronously
        _preloadImages(currentScreenImages);
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

        // Preload images asynchronously
        _preloadImages(targetList);
      }
    } catch (e) {
      print("Error fetching old try-on images for index $index: $e");
    }
  }

  // Helper method to preload images asynchronously
  void _preloadImages(List<String> imageUrls) {
    for (String url in imageUrls) {
      precacheImage(CachedNetworkImageProvider(url), context).catchError((e) {
        print("Error preloading image: $e");
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
        if (mounted) {
          setState(() {
            buyerImageUrls = List<String>.from(response.map((photo) => photo['photo_url']));
            buyerImageIds = List<String>.from(response.map((photo) => photo['photo_id']));
            
            // Immediately set the first image in currentScreenImages
            if (buyerImageUrls.isNotEmpty) {
              currentScreenImages = [buyerImageUrls.first];
            }
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
        isGeneratingTryOn = true; // Set the new flag for try-on generation
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
        isGeneratingTryOn = false; // Reset the flag after try-on generation
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

  // Helper method to upload an image to Supabase Storage with progress tracking
  Future<String> _uploadToSupabaseStorageWithProgress(String buyerId, String? dependentId, XFile pickedFile) async {
    try {
      final bytes = await pickedFile.readAsBytes();
      String fileName = "buyer_${DateTime.now().millisecondsSinceEpoch}.webp";

      // Simulate upload progress
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        if (mounted) {
          setState(() {
            _uploadProgress = i / 10.0; // Update progress
          });
        }
      }

      if (dependentId == null) {
        // Upload to buyer's folder
        final storageResponse = await supabase.storage
            .from('fiton')
            .uploadBinary('buyer_images/$buyerId/$fileName', bytes, fileOptions: FileOptions(contentType: "image/webp"));
        return "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/fiton/buyer_images/$buyerId/$fileName";
      } else {
        // Upload to dependent's folder
        final storageResponse = await supabase.storage
            .from('fiton')
            .uploadBinary('buyer_images/$buyerId/$dependentId/$fileName', bytes, fileOptions: FileOptions(contentType: "image/webp"));
        return "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/fiton/buyer_images/$buyerId/$dependentId/$fileName";
      }
    } catch (e) {
      print("Error uploading image to Supabase: $e");
    }
    return "";
  }

  // Method to store the uploaded image URL in the database
  Future<String> _storeUploadedPhoto(String buyerId, String? dependentId, String photoUrl, String photoType) async {
    try {
      final response = await supabase.from('photos').insert({
        "buyer_id": buyerId,
        "dependent_id": dependentId,
        "photo_url": photoUrl,
        "photo_type": photoType,
        "created_at": DateTime.now().toIso8601String(),
      }).select('photo_id');

      if (response.isNotEmpty) {
        print("Photo record inserted successfully!");
        return response[0]['photo_id'];
      } else {
        print("Error inserting photo record: Response is null or empty.");
        return "";
      }
    } catch (e) {
      print("Error storing photo data: $e");
      return "";
    }
  }

  // Method to open the device media gallery and upload a new buyer image
  Future<void> _openMediaGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        // Ask the user to choose between "Full-Body" and "Upper-Body"
        String? photoType = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Select Photo Type"),
              content: Text("Is this a Full-Body or Upper-Body photo?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, "Full-Body"),
                  child: Text("Full-Body"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, "Upper-Body"),
                  child: Text("Upper-Body"),
                ),
              ],
            );
          },
        );

        if (photoType == null) {
          print("Photo type selection canceled.");
          return;
        }

        // Show progress indicator
        if (mounted) {
          setState(() {
            _uploadProgress = 0.0;
            isLoading = true;
          });
        }

        // Upload the selected image to Supabase with progress tracking
        final uploadedUrl = await _uploadToSupabaseStorageWithProgress(buyer_id, dependent_id, pickedFile);

        if (uploadedUrl.isNotEmpty) {

          // Store the uploaded image URL in the database
          final photoId = await _storeUploadedPhoto(buyer_id, dependent_id, uploadedUrl, photoType);

          // Add the new image to the buyerImageUrls and update the state
          if (mounted) {
            setState(() {
              buyerImageUrls.add(uploadedUrl);
              buyerImageIds.add(photoId); // new photoId
              BuyerImageCurrentIndex = buyerImageUrls.length - 1; // Update to the last image
              _currentImageUrl = uploadedUrl; // Set the current image URL
              currentScreenImages = [uploadedUrl]; // Update currentScreenImages with the new image
              _uploadProgress = 0.0; // Reset progress
              isLoading = false; // Hide progress indicator
            });

            // Jump to the last page to show the uploaded image
            _pageController.jumpToPage(BuyerImageCurrentIndex);
          }

          print("Image uploaded and stored successfully: $uploadedUrl");
        } else {
          print("Error: Uploaded URL is empty.");
          if (mounted) {
            setState(() {
              isLoading = false; // Hide progress indicator
            });
          }
        }
      } catch (e) {
        print("Error selecting or uploading image: $e");
        if (mounted) {
          setState(() {
            isLoading = false; // Hide progress indicator
          });
        }
      }
    }
  }

  // Method to delete the current image
  Future<void> deleteCurrentImage() async {
    if (_currentImageUrl == null || BuyerImageCurrentIndex >= buyerImageIds.length) {
      print("Delete FitON selected: No image to delete or index out of bounds.");
      return;
    }

    try {
      // Extract the file path from the URL
      final filePath = _currentImageUrl!.split('/storage/v1/object/public/fiton/').last;
      print("Attempting to delete file at path: $filePath");

      // Delete the image from Supabase Storage
      final storageResponse = await supabase.storage.from('fiton').remove([filePath]);
      print("Storage deletion response: $storageResponse");

      // Delete the image record from the database
      final dbResponse = await supabase.from('photos').delete().eq('photo_id', buyerImageIds[BuyerImageCurrentIndex]);
      print("Database deletion response: $dbResponse");

      if (mounted) {
        // Trigger fade-out and slide-up animation
        setState(() {
          _imageOpacity = 0.0; // Start fade-out
        });
        await _animationController.forward(); // Start slide-up animation

        await Future.delayed(Duration(milliseconds: 300), () async {
          setState(() {
            // Remove the image from the lists
            buyerImageUrls.removeAt(BuyerImageCurrentIndex);
            buyerImageIds.removeAt(BuyerImageCurrentIndex);

            // Update the current index and images
            if (BuyerImageCurrentIndex >= buyerImageUrls.length) {
              BuyerImageCurrentIndex = buyerImageUrls.isEmpty ? 0 : buyerImageUrls.length - 1;
            }
            _currentImageUrl = buyerImageUrls.isNotEmpty ? buyerImageUrls[BuyerImageCurrentIndex] : null;

            // Update the current screen images
            currentScreenImages = buyerImageUrls.isNotEmpty
                ? [buyerImageUrls[BuyerImageCurrentIndex]]
                : [];
          });

          // Automatically swipe to the last image
          if (buyerImageUrls.isNotEmpty) {
            await _pageController.animateToPage(
              BuyerImageCurrentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        // Reset animation state
        _animationController.reset();
        setState(() {
          _imageOpacity = 1.0; // Reset opacity
        });
      }

      print("Image deleted successfully.");
    } catch (e) {
      print("Error deleting image: $e");
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
            itemCount: buyerImageUrls.isNotEmpty ? buyerImageUrls.length + 1 : 1, // Add 1 for the "add new image" page
            onPageChanged: (index) async {
              if (index == buyerImageUrls.length) {
                await _openMediaGallery(); // Open media gallery when swiping after the last image
              } else if (buyerImageUrls.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    BuyerImageCurrentIndex = index;
                    _currentImageUrl = buyerImageUrls[index]; // Update the current image URL
                  });
                }
                await _updateScreenImages();
              }
            },
            itemBuilder: (context, index) {
              if (index == buyerImageUrls.length) {
                // Hide the section until all images are preloaded
                if (!isImagesPreloaded) {
                  return SizedBox.shrink(); // Return an empty widget
                }
                return Stack(
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _openMediaGallery(); // Open media gallery when button is pressed
                        },
                        child: Text(
                          "Let's try a new photo",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x1B0331), // Button background color
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.grey, size: 24),
                          Text(
                            "Swipe Up",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

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
                      isGeneratingTryOn = true;
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
                      onPageChanged: (horizontalIndex) {
                        if (mounted && imagesToShow.isNotEmpty && horizontalIndex < imagesToShow.length) {
                          setState(() {
                            _currentImageUrl = imagesToShow[horizontalIndex]; // Update the current image URL
                          });
                        }
                      },
                      itemBuilder: (context, index) {
                        if (imagesToShow.isEmpty) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return _buildTryOnImage(imagesToShow[index]);
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          // Back Overlay
          Positioned(top: 0, left: 0, right: 0, child: _buildBackOverlay()),

          // Download Overlay
          Positioned(top: 0, left: 0, right: 0, child: _buildDownloadOverlay(_currentImageUrl ?? '')),

          // Bottom Overlay
          Positioned(bottom: 0, left: 0, right: 0, child: _buildStaticBottomOverlay()),

          // Loading Overlay for Try-On Generation
          if (isGeneratingTryOn)
            Positioned.fill(
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
                        _getLoadingPhaseMessage(), // Show phased messages
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

          // Loading Overlay for Image Upload
          if (isLoading && !isGeneratingTryOn)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(value: _uploadProgress),
                    const SizedBox(height: 20),
                    Text(
                      "Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Try-on image builder
  Widget _buildTryOnImage(String imageUrl) {
    return Stack(
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: AnimatedOpacity(
            opacity: _imageOpacity,
            duration: const Duration(milliseconds: 300),
            child: SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.scaleDown,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
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
                  child: RightBottomButtons(
                    tryOnScreenState: this, // Pass the current state
                  ),
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
}