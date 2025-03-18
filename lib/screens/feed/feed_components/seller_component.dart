import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellerComponent extends StatefulWidget {
  final String profileImage;
  final String name;
  final String shopId;
  final VoidCallback onTap;

  const SellerComponent({
    Key? key,
    this.profileImage = 'assets/images/feed/profile.jpg',
    required this.name,
    required this.shopId,
    required this.onTap,
  }) : super(key: key);

  @override
  _SellerComponentState createState() => _SellerComponentState();
}

class _SellerComponentState extends State<SellerComponent> {
  int followersCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFollowersCount();
  }

  @override
  void didUpdateWidget(SellerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shopId != widget.shopId) {
      _fetchFollowersCount();
    }
  }

  Future<void> _fetchFollowersCount() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      print('Fetching followers count for shop: ${widget.shopId}'); // Debug log

      // Count followers from followers table for this specific shop
      final response = await Supabase.instance.client
          .from('followers')
          .select()
          .eq('shop_id', widget.shopId);

      final count = response.length;
      print('Found $count followers for shop ${widget.shopId}'); // Debug log

      if (mounted) {
        setState(() {
          followersCount = count;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching followers count: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String formatFollowersCount(int count) {
    if (count >= 1000000) {
      double m = count / 1000000;
      return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
    }
    if (count >= 1000) {
      double k = count / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                  image: widget.profileImage.startsWith('assets/')
                      ? AssetImage(widget.profileImage) as ImageProvider
                      : NetworkImage(widget.profileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      Text(
                        '${formatFollowersCount(followersCount)} Followers',
                        style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}
