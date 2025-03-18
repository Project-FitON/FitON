import 'package:flutter/material.dart';
import 'package:fiton/models/review_model.dart';
import 'package:fiton/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/shop_model.dart';
import 'feed_components/more_details_component.dart';
import 'feed_components/seller_component.dart';
import 'feed_components/top_buttons_component.dart';
import 'feed_components/favourite_component.dart';
import 'feed_components/reviews_component.dart';
import 'feed_components/product_component.dart';
import 'feed_components/navigation_component.dart';
import 'feed_components/main_buttons_component.dart';
import 'tryon_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  List<Review> reviews = [];
  List<ProductModel> products = [];
  Map<String, ShopModel> shops = {};  // Cache for shop data
  bool isLoading = true;
  String? error;
  int currentProductIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchData();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  Future<void> _fetchShopData(String shopId) async {
    if (!shops.containsKey(shopId)) {
      try {
        print('Fetching shop data for shopId: $shopId');
        
        // Simple query to get shop data
        final response = await Supabase.instance.client
            .from('shops')
            .select()
            .eq('shop_id', shopId)
            .single();
        
        print('Shop response raw: $response');
        
        if (response != null) {
          setState(() {
            shops[shopId] = ShopModel(
              shopId: response['shop_id'] ?? '',
              shopName: response['shop_name'] ?? 'Shop',
              email: response['email'] ?? '',
              passwordHash: response['password_hash'] ?? '',
              profilePhoto: response['profile_photo'],
              cashOnDelivery: response['cash_on_delivery'] ?? false,
              createdAt: DateTime.parse(response['created_at'] ?? DateTime.now().toIso8601String()),
              updatedAt: DateTime.parse(response['updated_at'] ?? DateTime.now().toIso8601String()),
            );
          });
          
          print('Set shop in state with name: ${shops[shopId]?.shopName}');
        } else {
          print('Shop response was null');
          // Set a default shop model to avoid loading state
          setState(() {
            shops[shopId] = ShopModel(
              shopId: shopId,
              shopName: 'Shop',
              email: '',
              passwordHash: '',
              cashOnDelivery: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          });
        }
      } catch (e, stackTrace) {
        print('Error fetching shop data: $e');
        print('Stack trace: $stackTrace');
        // Set a default shop model on error
        setState(() {
          shops[shopId] = ShopModel(
            shopId: shopId,
            shopName: 'Shop',
            email: '',
            passwordHash: '',
            cashOnDelivery: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        });
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedProducts = await ProductModel.fetchProducts();
      final fetchedReviews = await Review.fetchReviews();
      
      if (mounted) {
        setState(() {
          products = fetchedProducts;
          reviews = fetchedReviews;
          isLoading = false;
        });

        // Fetch shop data for the first product
        if (products.isNotEmpty) {
          await _fetchShopData(products[currentProductIndex].shopId);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load data. Please try again.';
          isLoading = false;
        });
      }
    }
  }

  void loadNextProduct() {
    if (currentProductIndex < products.length - 1) {
      setState(() {
        currentProductIndex++;
      });
      _controller.forward(from: 0);
      // Fetch shop data for the next product
      _fetchShopData(products[currentProductIndex].shopId);
    }
  }

  void loadPreviousProduct() {
    if (currentProductIndex > 0) {
      setState(() {
        currentProductIndex--;
      });
      _controller.reverse(from: 1);
      // Fetch shop data for the previous product
      _fetchShopData(products[currentProductIndex].shopId);
    }
  }

  Future<void> _refreshFeed() async {
    await _fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current shop
    final currentShop = products.isNotEmpty && shops.containsKey(products[currentProductIndex].shopId)
        ? shops[products[currentProductIndex].shopId]
        : null;

    return RefreshIndicator(
      onRefresh: _refreshFeed,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            loadNextProduct();
          } else if (details.primaryVelocity! > 0) {
            loadPreviousProduct();
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => TryOnScreen(
                  shopId: products[currentProductIndex].shopId,
                  productId: products[currentProductIndex].productId,
                  price: products[currentProductIndex].price,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
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
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (error != null)
                  Center(child: Text(error!, style: TextStyle(color: Colors.white)))
                else if (products.isEmpty)
                  Center(child: Text('No products available', style: TextStyle(color: Colors.white)))
                else ...[
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
                            child: SellerComponent(
                              name: currentShop?.shopName ?? 'Loading...',
                              shopId: products[currentProductIndex].shopId,
                              profileImage: currentShop?.profilePhoto ?? 'assets/images/feed/profile.jpg',
                              onTap: () {},
                            ),
                          ),
                          // Favorite Component
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: FavouriteComponent(
                              key: ValueKey(products[currentProductIndex].productId),
                              reviewId: reviews.isNotEmpty ? reviews[currentProductIndex].reviewId : '00000000-0000-0000-0000-000000000000',
                              productId: products[currentProductIndex].productId,
                              initialFavoriteCount: products[currentProductIndex].likes,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Top Buttons Component
                  Positioned(
                    top: 50,
                    right: 16,
                    child: TopButtonsComponent(),
                  ),
                  // Bottom Section (Reviews, Product, Navigation)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.0),
                          ],
                          stops: [0.0, 0.3, 0.6, 1.0],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 160),
                              // Product Component at bottom
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ProductComponent(
                                        product: products[currentProductIndex],
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Navigation Component
                              Padding(
                                padding: const EdgeInsets.only(top: 24, bottom: 16),
                                child: NavigationComponent(),
                              ),
                            ],
                          ),
                          // Reviews Component positioned above product
                          Positioned(
                            bottom: 140,
                            left: 0,
                            right: 0,
                            child: reviews.isEmpty
                                ? Center(child: Text("No Reviews Yet"))
                                : ReviewsComponent(
                                    reviewId: reviews[currentProductIndex].reviewId,
                                    commenterName: 'User ${reviews[currentProductIndex].buyerId}',
                                    comment: reviews[currentProductIndex].comment,
                                    likes: products[currentProductIndex].likes,
                                    rating: reviews[currentProductIndex].rating.toDouble(),
                                    onTap: () {},
                                  ),
                          ),
                          // Main Buttons Component in middle of screen
                          Positioned(
                            bottom: 250,
                            left: 0,
                            right: 0,
                            child: MainButtonsComponent(
                              shopId: products[currentProductIndex].shopId,
                              productId: products[currentProductIndex].productId,
                              price: products[currentProductIndex].price,
                              onFollowSuccess: () {
                                _fetchShopData(products[currentProductIndex].shopId);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right Bottom Buttons - aligned with product component
                  Positioned(
                    right: 16,
                    bottom: 90,
                    child: RightBottomButtons(),
                  ),
                  // Slide Animation Container
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
