import 'package:flutter/material.dart';
import 'package:fiton/models/review_model.dart';
import 'feed_components/more_details_component.dart'; // Import the RightBottomButtons component
import 'feed_components/seller_component.dart'; // Import the SellerComponent
import 'feed_components/top_buttons_component.dart'; // Import the Top Buttons component
import 'feed_components/favourite_component.dart'; // Import the FavoriteComponent
import 'feed_components/reviews_component.dart';
import 'feed_components/product_component.dart'; // Import the ProductComponent
import 'feed_components/navigation_component.dart';
import 'feed_components/main_buttons_component.dart'; // Import Main Buttons component
import 'tryon_screen.dart'; // Import the TryOnScreen

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  List<Review> reviews = [];
  bool isLoading = true;
  int currentProductIndex = 0;
  late AnimationController _controller; // Animation controller for smooth product transitions
  late Animation<Offset> _slideAnimation; // Slide animation for smooth transitions

  @override
  void initState() {
    super.initState();
    fetchReviews();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Set up the slide animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Start from the bottom (for up swipe)
      end: Offset.zero, // End at the current position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> fetchReviews() async {
    final fetchedReviews = await Review.fetchReviews();
    setState(() {
      reviews = fetchedReviews;
      isLoading = false;
    });
  }

  void loadNextProduct() {
    if (currentProductIndex < reviews.length - 1) {
      setState(() {
        currentProductIndex++;
      });
    }
  }

  void loadPreviousProduct() {
    if (currentProductIndex > 0) {
      setState(() {
        currentProductIndex--;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Left swipe detected, navigate to TryOnScreen with animation
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => TryOnScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1, 0), // Slide from right to left
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        } else if (details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Up swipe detected, load the next product with smooth animation
          loadNextProduct();
          _controller.forward(from: 0); // Start the slide animation from bottom to top
        } else if (details.primaryVelocity! > 0) {
          // Down swipe detected, load the previous product with smooth animation
          loadPreviousProduct();
          _controller.reverse(from: 1); // Start the slide animation from top to bottom
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset('assets/images/feed/recommed.jpg', fit: BoxFit.cover),
              ),
              // Top Section (Seller, Favorite Components)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seller Component
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SellerComponent(onTap: () {}),
                      ),
                      // Favorite Component (Positioned after the Seller)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FavouriteComponent(
                          reviewId: reviews.isNotEmpty ? reviews[currentProductIndex].reviewId : '00000000-0000-0000-0000-000000000000',
                          initialFavoriteCount: reviews.isNotEmpty ? reviews[currentProductIndex].likes : 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Top Buttons Component - Positioned at the top-right corner
              Positioned(
                top: 50,
                right: 16,
                child: TopButtonsComponent(),
              ),
              // Main Buttons Component - Positioned with bottom: 250
              Positioned(
                left: 16,
                right: 16,
                bottom: 250,
                child: MainButtonsComponent(),
              ),
              // Bottom Section (Reviews, Product, Navigation Buttons)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                        // Reviews Section (Placed below the Main Buttons)
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : reviews.isEmpty
                              ? Center(child: Text("No Reviews Yet"))
                              : ReviewsComponent(
                            reviewId: reviews[currentProductIndex].reviewId,
                            commenterName: 'User ${reviews[currentProductIndex].buyerId}',
                            comment: reviews[currentProductIndex].comment,
                            likes: reviews[currentProductIndex].likes,
                            rating: reviews[currentProductIndex].rating.toDouble(),
                            onTap: () {},
                          ),
                        ),
                        // Product Section (No background color applied)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ProductComponent(onTap: () {}),
                        ),
                        // Bottom navigation buttons
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: NavigationComponent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Right Bottom Buttons, always at the bottom-right corner
              Positioned(
                right: 16,
                bottom: 120,
                child: RightBottomButtons(),
              ),
              // Smooth Slide for Product Transition (only for vertical swipes)
              Positioned.fill(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(), // The product image or details to slide smoothly
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
