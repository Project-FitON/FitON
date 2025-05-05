import 'package:fiton/services/placeholder_service.dart';
import 'package:fiton/services/feed_service.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  int currentProductIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isFetchingMore = false;
  int _offset = 0;
  final int _limit = 10;
  double _dragDistance = 0;
  bool _isDragging = false;
  List<Review> reviews = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  late PageController _horizontalPageController;

  @override
  void initState() {
    super.initState();
    fetchFeedItems();

    _horizontalPageController = PageController(initialPage: 0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && !_isFetchingMore) {
        fetchFeedItems();
      }
    }
  }

  Future<void> fetchFeedItems() async {
    if (_isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
      _isLoadingMore = true;
    });

    try {
      final newReviews = await FeedService.getFeedItems(
        limit: _limit,
        offset: _offset,
      );

      if (mounted) {
        setState(() {
          if (_offset == 0) {
            reviews = newReviews;
          } else {
            reviews.addAll(newReviews);
          }
          _offset += newReviews.length;
          isLoading = false;
          _isFetchingMore = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      print('Error fetching feed items: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          _isFetchingMore = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void loadNextProduct() {
    if (currentProductIndex < reviews.length - 1) {
      setState(() {
        currentProductIndex++;
      });
      _controller.forward(from: 0);
    } else if (!_isFetchingMore && currentProductIndex >= reviews.length - 3) {
      fetchFeedItems();
    }
  }

  void loadPreviousProduct() {
    if (currentProductIndex > 0) {
      setState(() {
        currentProductIndex--;
      });
      _controller.reverse(from: 1);
    }
  }

  Future<void> handleLike(String reviewId, int currentLikes) async {
    final newLikeCount = currentLikes + 1;
    final success = await FeedService.updateLikes(reviewId, newLikeCount);

    if (success) {
      setState(() {
        final reviewIndex = reviews.indexWhere((r) => r.reviewId == reviewId);
        if (reviewIndex != -1) {
          final updatedReview = Review(
            reviewId: reviews[reviewIndex].reviewId,
            productId: reviews[reviewIndex].productId,
            buyerId: reviews[reviewIndex].buyerId,
            shopId: reviews[reviewIndex].shopId,
            rating: reviews[reviewIndex].rating,
            comment: reviews[reviewIndex].comment,
            likes: newLikeCount,
            createdAt: reviews[reviewIndex].createdAt,
          );
          reviews[reviewIndex] = updatedReview;
        }
      });
    }
  }

  void navigateToTryOnScreen(BuildContext context, String buyerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder<String?>(
          future: PlaceholderService.preloadPlaceholderUrl(context, buyerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text("Error loading placeholder"),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return TryOnScreen(
                preloadedPlaceholderUrl: snapshot.data,
                pageController: PageController(), // Pass a new PageController
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: Text("No placeholder available"),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _horizontalPageController.dispose();
    super.dispose();
  }

  Widget _buildProductContent(Review review) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child:
              review.product?.images?.isNotEmpty == true &&
                      review.product!.images!.first.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: review.product!.images!.first,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/feed/recommed.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    memCacheWidth: 1080, // Optimize for most phone screens
                    maxWidthDiskCache: 1920, // Max width to cache on disk
                  )
                  : Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/feed/recommed.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
        ),
        // Top Section (Seller, Favorite Components)
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SellerComponent(
                  profileImage:
                      review.shop?.profilePhoto ??
                      'assets/images/feed/commente.jpg',
                  name: review.shop?.shopName ?? 'Shop Name',
                  shopId: review.shopId,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                FavouriteComponent(
                  reviewId: review.reviewId,
                  initialFavoriteCount: review.likes,
                ),
              ],
            ),
          ),
        ),
        // Top Buttons Component
        const Positioned(top: 50, right: 16, child: TopButtonsComponent()),
        // Main Buttons Component (Follow, Cart, Buy Now)
        Positioned(
          left: 0,
          right: 0,
          bottom: 180,
          child: MainButtonsComponent(
            orderCount: review.product?.ordersCount ?? 0,
            shopId: review.shopId,
            productId: review.productId,
            price: review.product?.price,
            productName: review.product?.name,
            imageUrl:
                review.product?.images?.isNotEmpty == true
                    ? review.product!.images.first
                    : null,
          ),
        ),
        // Bottom Section with Reviews and Product Info
        Positioned(
          bottom: 55,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.0),
                ],
                stops: const [0.0, 0.8],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ReviewsComponent(
                  reviewId: review.reviewId,
                  commenterName: 'User ${review.buyerId.substring(0, 8)}',
                  comment: review.comment,
                  likes: review.likes,
                  rating: review.rating.toDouble(),
                  onTap: () {},
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ProductComponent(
                    title: review.product?.name ?? 'Product Name',
                    realPrice: review.product?.price ?? 0.0,
                    discountPrice: (review.product?.price ?? 0.0) * 1.2,
                    discountPercentage: 20,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
        // Right Bottom Buttons
        const Positioned(right: 16, bottom: 120, child: RightBottomButtons()),
        // Navigation Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.black, child: NavigationComponent()),
        ),
      ],
    );
  }

  Widget _buildFeedPage() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reviews.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return PageView.builder(
      controller: PageController(viewportFraction: 1.0),
      scrollDirection: Axis.vertical,
      itemCount: reviews.length + (_isLoadingMore ? 1 : 0),
      onPageChanged: (index) {
        if (index == reviews.length - 3 && !_isFetchingMore) {
          fetchFeedItems();
        }
      },
      itemBuilder: (context, index) {
        if (index == reviews.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildProductContent(reviews[index]);
      },
    );
  }

  Widget _buildTryOnPage() {
    if (reviews.isEmpty || currentProductIndex >= reviews.length) {
      return const Center(child: Text("No placeholder available"));
    }

    return FutureBuilder<String?>(
      future: PlaceholderService.preloadPlaceholderUrl(
          context, reviews[currentProductIndex].buyerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading placeholder"));
        } else if (snapshot.hasData && snapshot.data != null) {
          return TryOnScreen(
            preloadedPlaceholderUrl: snapshot.data,
            pageController: PageController(),
          );
        } else {
          return const Center(child: Text("No placeholder available"));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _horizontalPageController,
        scrollDirection: Axis.horizontal,
        children: [
          _buildFeedPage(),
          _buildTryOnPage(),
        ],
      ),
    );
  }
}
