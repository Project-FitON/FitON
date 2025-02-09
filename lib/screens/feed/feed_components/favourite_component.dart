import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteComponent extends StatefulWidget {
  final String reviewId; // Required to identify the review in Supabase
  final int initialFavoriteCount;

  const FavouriteComponent({
    Key? key,
    required this.reviewId, // Required review ID
    this.initialFavoriteCount = 0, // Start with 0 likes by default
  }) : super(key: key);

  @override
  _FavouriteComponentState createState() => _FavouriteComponentState();
}

class _FavouriteComponentState extends State<FavouriteComponent> {
  late int favoriteCount;
  late Color countColor;
  late Color iconColor;
  bool isTapped = false;

  final SupabaseClient supabase = Supabase.instance.client; // Supabase client

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.initialFavoriteCount; // Start with 0 likes
    countColor = Colors.white;
    iconColor = Colors.white;

    // Fetch initial likes count from Supabase
    _fetchLikes();
  }

  /// Fetch the likes count from Supabase
  Future<void> _fetchLikes() async {
    final response = await supabase
        .from('reviews')
        .select('likes')
        .eq('review_id', widget.reviewId)
        .single(); // Use 'single()' instead of execute()

    if (response.error != null) {
      print('Error fetching likes: ${response.error!.message}');
    } else {
      setState(() {
        // If no likes exist in the database, initialize it to 0
        favoriteCount = response.data['likes'] ?? widget.initialFavoriteCount;
      });
    }
  }

  /// Toggle favorite and update Supabase
  void _toggleFavorite() async {
    setState(() {
      isTapped = !isTapped;
      if (isTapped) {
        favoriteCount++; // Increment like count
        countColor = Colors.red;
        iconColor = Colors.red;
      } else {
        favoriteCount--; // Decrease the count if unliked
        countColor = Colors.white;
        iconColor = Colors.white;
      }
    });

    // Update the likes count in Supabase
    final response = await supabase
        .from('reviews')
        .update({'likes': favoriteCount})
        .eq('review_id', widget.reviewId); // Use update directly, no need for execute()

    if (response.error != null) {
      print('Error updating likes: ${response.error!.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double componentWidth = screenWidth * 0.1;

    // Format the favorite count to display either with or without 'K'
    String formattedCount;
    if (favoriteCount < 1000) {
      formattedCount = favoriteCount.toString();
    } else {
      formattedCount = (favoriteCount / 1000).toStringAsFixed(1) + 'K';
    }

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

extension on PostgrestMap {
  get error => null;

  get data => null;
}
