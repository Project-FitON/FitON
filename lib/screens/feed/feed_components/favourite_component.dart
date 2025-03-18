import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteComponent extends StatefulWidget {
  final String reviewId;
  final int initialFavoriteCount;

  const FavouriteComponent({
    super.key,
    required this.reviewId,
    this.initialFavoriteCount = 0,
  });

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

    _fetchLikes(); // Fetch initial likes count
    _subscribeToRealtimeUpdates(); // Listen for live updates
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
      }
    } catch (error) {
      print('Error fetching likes: $error');
    }
  }

  /// Subscribe to real-time changes in Supabase
  void _subscribeToRealtimeUpdates() {
    supabase
        .from('reviews')
        .stream(primaryKey: ['review_id']) // Listen for changes based on primary key
        .eq('review_id', widget.reviewId) // Filter to only this review
        .listen((List<Map<String, dynamic>> data) {
      if (data.isNotEmpty && data.first.containsKey("likes")) {
        setState(() {
          favoriteCount = data.first["likes"] as int;
        });
      }
    });
  }

  /// Toggle favorite and update Supabase
  Future<void> _toggleFavorite() async {
    setState(() {
      isTapped = !isTapped;
      favoriteCount = isTapped ? favoriteCount + 1 : favoriteCount - 1;
      countColor = isTapped ? Colors.red : Colors.white;
      iconColor = isTapped ? Colors.red : Colors.white;
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
  void dispose() {
    supabase.removeAllChannels(); // Unsubscribe from all Supabase real-time channels
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double componentWidth = screenWidth * 0.1;

    // Format the favorite count for display
    String formattedCount = favoriteCount < 1000
        ? favoriteCount.toString()
        : '${(favoriteCount / 1000).toStringAsFixed(1)}K';

    return ElevatedButton(
      onPressed: _toggleFavorite,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
      ),
      child: SizedBox(
        width: componentWidth,
        height: componentWidth * 1.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
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
