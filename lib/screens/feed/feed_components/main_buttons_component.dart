import 'package:flutter/material.dart';
import '../../../services/shop_service.dart';
import '../../../services/cart_service.dart';
import '../../../models/cart_items_model.dart';
import '../buy_now_screen.dart';

class MainButtonsComponent extends StatefulWidget {
  final int orderCount;
  final String? shopId;
  final String? productId;
  final double? price;
  final String? productName;
  final String? imageUrl;

  const MainButtonsComponent({
    super.key,
    this.orderCount = 0,
    this.shopId,
    this.productId,
    this.price,
    this.productName,
    this.imageUrl,
  });

  @override
  State<MainButtonsComponent> createState() => _MainButtonsComponentState();
}

class _MainButtonsComponentState extends State<MainButtonsComponent> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    if (widget.shopId == null) return;
    final following = await ShopService.isFollowingShop(widget.shopId!);
    if (mounted) {
      setState(() => isFollowing = following);
    }
  }

  Future<void> _toggleFollow() async {
    print("Follow button tapped");
    if (widget.shopId == null || widget.shopId!.isEmpty) {
      _showMessage('Shop information not available');
      return;
    }

    bool success;
    if (isFollowing) {
      success = await ShopService.unfollowShop(widget.shopId);
      if (success) {
        setState(() => isFollowing = false);
        _showMessage('Shop unfollowed');
      }
    } else {
      success = await ShopService.followShop(widget.shopId);
      if (success) {
        setState(() => isFollowing = true);
        _showMessage('Shop followed successfully!');
      }
    }

    if (!success) {
      _showMessage('Action failed. Please try again.');
    }
  }

  Future<void> _addToCart() async {
    print("Cart button tapped");
    if (widget.productId == null) {
      _showMessage('Product information not available');
      return;
    }

    final success = await CartService.addToCart(widget.productId!);
    if (success) {
      _showMessage('Added to cart successfully!');
    } else {
      _showMessage('Failed to add to cart. Please try again.');
    }
  }

  void _buyNow() {
    print("Buy now button tapped");
    if (widget.productId == null ||
        widget.price == null ||
        widget.productName == null ||
        widget.imageUrl == null) {
      _showMessage('Product information not available');
      return;
    }

    final cartItem = CartItems(
      cartItemId: 'temp_${widget.productId}',
      cartId: 'temp_cart',
      productId: widget.productId!,
      quantity: 1,
      selectedSize: 'M',
      selectedColor: 'Default',
      createdAt: DateTime.now(),
      imageUrl: widget.imageUrl!,
      productName: widget.productName!,
      productPrice: widget.price!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                CheckoutScreen(cartItems: [cartItem], total: widget.price!),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Follow button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleFollow,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isFollowing ? Colors.yellow : Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/feed/follow.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 120),
              // Cart button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _addToCart,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/feed/cart.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Buy now button with larger tap area
        Container(
          width: 120,
          height: 120,
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print("Buy now button tapped");
                      _buyNow();
                    },
                    customBorder: CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/images/feed/buy-now.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      _formatOrderCount(widget.orderCount),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatOrderCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
