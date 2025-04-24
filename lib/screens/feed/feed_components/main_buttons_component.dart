import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' as math;

class MainButtonsComponent extends StatefulWidget {
  final String shopId;
  final String productId;
  final double price;
  final Function? onFollowSuccess;

  const MainButtonsComponent({
    Key? key,
    required this.shopId,
    required this.productId,
    required this.price,
    this.onFollowSuccess,
  }) : super(key: key);

  @override
  _MainButtonsComponentState createState() => _MainButtonsComponentState();
}

class _MainButtonsComponentState extends State<MainButtonsComponent> {
  bool isFollowing = false;
  bool isLoading = false;
  bool isAddingToCart = false;
  bool isBuying = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      print('Current user ID: $userId'); // Debug log
      print('Shop ID: ${widget.shopId}'); // Debug log

      if (userId == null) {
        print('Error: User ID is null');
        return;
      }

      final response = await Supabase.instance.client
          .from('followers')
          .select()
          .eq('shop_id', widget.shopId)
          .eq('follower_id', userId)
          .maybeSingle();

      print('Follow status response: $response'); // Debug log

      setState(() {
        isFollowing = response != null;
      });
      print('Is following: $isFollowing'); // Debug log
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      print('Attempting to toggle follow for user: $userId and shop: ${widget.shopId}'); // Debug log

      if (userId == null) {
        print('Error: User ID is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to follow shops')),
        );
        return;
      }

      // Check if already following
      final existingFollow = await Supabase.instance.client
          .from('followers')
          .select()
          .eq('shop_id', widget.shopId)
          .eq('follower_id', userId)
          .maybeSingle();

      print('Existing follow status: ${existingFollow != null}'); // Debug log

      if (!isFollowing) {
        print('Adding follower...'); // Debug log
        
        // Add follower to followers table
        await Supabase.instance.client
            .from('followers')
            .insert({
              'shop_id': widget.shopId,
              'follower_id': userId,
              'created_at': DateTime.now().toIso8601String(),
            });

        setState(() {
          isFollowing = true;
        });
        
        print('Successfully added follower');
        widget.onFollowSuccess?.call(); // This will trigger seller component refresh

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop followed successfully!')),
        );
      } else {
        print('Removing follower...'); // Debug log
        
        // Remove follower from followers table
        await Supabase.instance.client
            .from('followers')
            .delete()
            .eq('shop_id', widget.shopId)
            .eq('follower_id', userId);

        setState(() {
          isFollowing = false;
        });

        print('Successfully removed follower');
        widget.onFollowSuccess?.call(); // This will trigger seller component refresh

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop unfollowed')),
        );
      }
    } catch (e) {
      print('Error toggling follow: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to ${isFollowing ? 'unfollow' : 'follow'} shop. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _addToCart() async {
    if (isAddingToCart) return;

    setState(() {
      isAddingToCart = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to add items to cart')),
        );
        return;
      }

      // First, get or create a cart for the user
      var cartResponse = await Supabase.instance.client
          .from('carts')
          .select()
          .eq('buyer_id', userId)
          .single();

      String cartId;
      if (cartResponse == null) {
        // Create new cart
        final newCart = await Supabase.instance.client.from('carts').insert({
          'buyer_id': userId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).select().single();
        cartId = newCart['cart_id'];
      } else {
        cartId = cartResponse['cart_id'];
      }

      // Check if product already in cart
      final existingItem = await Supabase.instance.client
          .from('cart_items')
          .select()
          .eq('cart_id', cartId)
          .eq('product_id', widget.productId)
          .single();

      if (existingItem != null) {
        // Update quantity
        await Supabase.instance.client
            .from('cart_items')
            .update({'quantity': existingItem['quantity'] + 1})
            .eq('cart_id', cartId)
            .eq('product_id', widget.productId);
      } else {
        // Add new item
        await Supabase.instance.client.from('cart_items').insert({
          'cart_id': cartId,
          'product_id': widget.productId,
          'quantity': 1,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully!')),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart')),
      );
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  Future<void> _buyNow() async {
    if (isBuying) return;

    setState(() {
      isBuying = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to make a purchase')),
        );
        return;
      }

      // Create a new order
      final order = await Supabase.instance.client.from('orders').insert({
        'buyer_id': userId,
        'shop_id': widget.shopId,
        'status': 'pending',
        'payment_method': 'pending',
        'total_price': widget.price,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).select().single();

      // Add order item
      await Supabase.instance.client.from('order_items').insert({
        'order_id': order['order_id'],
        'product_id': widget.productId,
        'quantity': 1,
        'price': widget.price,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      // Navigate to checkout screen
      Navigator.pushNamed(context, '/checkout', arguments: {
        'orderId': order['order_id'],
        'totalPrice': widget.price,
      });

    } catch (e) {
      print('Error creating order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order')),
      );
    } finally {
      setState(() {
        isBuying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Move the Row down slightly to overlap with the Stack
        Transform.translate(
          offset: Offset(0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Follow button
              GestureDetector(
                onTap: _toggleFollow,
                child: Container(
                  width: 25,
                  height: 25,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Image.asset(
                          isFollowing
                              ? 'assets/images/feed/following.png'
                              : 'assets/images/feed/follow.png',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              SizedBox(width: 150),
              // Cart button
              GestureDetector(
                onTap: _addToCart,
                child: Container(
                  width: 25,
                  height: 25,
                  child: isAddingToCart
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Image.asset(
                          'assets/images/feed/cart.png',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ],
          ),
        ),

        // Buy Now button
        GestureDetector(
          onTap: _buyNow,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                child: isBuying
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/feed/buy-now.png',
                        fit: BoxFit.contain,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}