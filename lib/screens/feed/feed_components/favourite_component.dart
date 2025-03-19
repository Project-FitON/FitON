import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteComponent extends StatefulWidget {
  final String reviewId;
  final String productId;
  final int initialFavoriteCount;

  const FavouriteComponent({
    Key? key,
    required this.reviewId,
    required this.productId,
    this.initialFavoriteCount = 0,
  }) : super(key: key);

  @override
  _FavouriteComponentState createState() => _FavouriteComponentState();
}

class _FavouriteComponentState extends State<FavouriteComponent> {
  late int favoriteCount;
  bool isTapped = false;
  bool isLoading = false;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.initialFavoriteCount;
    _fetchLikes();
  }

  /// Fetch likes count from Supabase
  Future<void> _fetchLikes() async {
    try {
      final response = await supabase
          .from('reviews')
          .select('likes')
          .eq('review_id', widget.reviewId)
          .single();

      if (mounted && response != null) {
        setState(() {
          favoriteCount = response['likes'] ?? 0;
        });
      }
    } catch (error) {
      print('Error fetching likes: $error');
    }
  }

  /// Toggle favorite and update Supabase
  Future<void> _toggleFavorite() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Toggle state first
      final newIsTapped = !isTapped;
      final newLikes = newIsTapped ? favoriteCount + 1 : favoriteCount - 1;
      final finalLikes = newLikes >= 0 ? newLikes : 0;

      // Update reviews table
      await supabase
          .from('reviews')
          .update({'likes': finalLikes})
          .eq('review_id', widget.reviewId);

      // Update products table
      await supabase
          .from('products')
          .update({'likes': finalLikes})
          .eq('product_id', widget.productId);

      // Update local state
      setState(() {
        isTapped = newIsTapped;
        favoriteCount = finalLikes;
      });
    } catch (error) {
      print('Error updating likes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update likes. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double componentWidth = screenWidth * 0.1;

    String formattedCount = favoriteCount < 1000
        ? favoriteCount.toString()
        : (favoriteCount / 1000).toStringAsFixed(1) + 'K';

    return ElevatedButton(
      onPressed: _toggleFavorite,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        width: componentWidth,
        height: componentWidth * 1.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: componentWidth,
              height: componentWidth,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isTapped ? Colors.red : Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/feed/favourit.png',
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedCount,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
                color: isTapped ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}