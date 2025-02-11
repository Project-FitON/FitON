import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteComponent extends StatefulWidget {
  final String reviewId;
  final int initialFavoriteCount;

  const FavouriteComponent({
    Key? key,
    required this.reviewId,
    this.initialFavoriteCount = 0,
  }) : super(key: key);

  @override
  _FavouriteComponentState createState() => _FavouriteComponentState();
}

class _FavouriteComponentState extends State<FavouriteComponent> {
  late int favoriteCount;
  late Color countColor;
  late Color iconColor;
  bool isTapped = false;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.initialFavoriteCount;
    countColor = Colors.white;
    iconColor = Colors.white;

    _fetchLikes(); // Fetch likes count from Supabase
  }

  /// Fetch likes count from Supabase
  Future<void> _fetchLikes() async {
    try {
      final response = await supabase
          .from('reviews')
          .select('likes')
          .eq('review_id', widget.reviewId)
          .maybeSingle(); // Returns null if no data

      if (response != null && response.containsKey("likes")) {
        setState(() {
          favoriteCount = response["likes"] as int;
        });
      } else {
        setState(() {
          favoriteCount = 0; // Default to 0 if no likes field exists
        });
      }
    } catch (error) {
      print('Error fetching likes: $error');
    }
  }

  /// Toggle favorite and update Supabase
  Future<void> _toggleFavorite() async {
    setState(() {
      isTapped = !isTapped;
      if (isTapped) {
        favoriteCount++;
        countColor = Colors.red;
        iconColor = Colors.red;
      } else {
        favoriteCount--;
        countColor = Colors.white;
        iconColor = Colors.white;
      }
    });

    try {
      await supabase
          .from('reviews')
          .update({'likes': favoriteCount})
          .eq('review_id', widget.reviewId);
    } catch (error) {
      print('Error updating likes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double componentWidth = screenWidth * 0.1;

    // Format the favorite count for display
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
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  iconColor,
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
                color: countColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
