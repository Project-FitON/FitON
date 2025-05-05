import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/shop_service.dart';

class SellerComponent extends StatefulWidget {
  final String? profileImage;
  final String? name;
  final String? shopId;
  final VoidCallback onTap;

  const SellerComponent({
    super.key,
    this.profileImage,
    this.name,
    this.shopId,
    required this.onTap,
  });

  @override
  State<SellerComponent> createState() => _SellerComponentState();
}

class _SellerComponentState extends State<SellerComponent> {
  bool isFollowing = false;
  int followerCount = 0;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
    _getFollowerCount();
    _subscribeToFollowerUpdates();
  }

  Future<void> _checkFollowStatus() async {
    if (widget.shopId == null) return;
    final following = await ShopService.isFollowingShop(widget.shopId!);
    if (mounted) {
      setState(() => isFollowing = following);
    }
  }

  Future<void> _getFollowerCount() async {
    if (widget.shopId == null) return;
    final count = await ShopService.getShopFollowersCount(widget.shopId!);
    if (mounted) {
      setState(() => followerCount = count);
    }
  }

  void _subscribeToFollowerUpdates() {
    if (widget.shopId == null) return;

    Supabase.instance.client
        .from('followers')
        .stream(primaryKey: ['follow_id'])
        .eq('shop_id', widget.shopId!)
        .listen((data) {
          _getFollowerCount(); // Refresh count when followers change
        });
  }

  String _formatFollowerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M Followers';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K Followers';
    }
    return '$count Followers';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:
                      widget.profileImage != null
                          ? CachedNetworkImageProvider(widget.profileImage!)
                          : const AssetImage('assets/images/feed/profile.jpg')
                              as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name ?? 'Shop',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _formatFollowerCount(followerCount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Supabase.instance.client.removeAllChannels();
    super.dispose();
  }
}
