import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/feed_service.dart';
import 'dart:async';

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
  String? currentUserId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.initialFavoriteCount;
    countColor = Colors.white;
    iconColor = Colors.white;
    currentUserId = Supabase.instance.client.auth.currentUser?.id;

    _fetchLikes();
    _checkIfFavorited();
    _subscribeToRealtimeUpdates();
  }

  Future<void> _fetchLikes() async {
    try {
      final response =
          await Supabase.instance.client
              .from('reviews')
              .select('likes')
              .eq('review_id', widget.reviewId)
              .maybeSingle();

      if (!mounted) return;
      if (response != null && response.containsKey("likes")) {
        setState(() {
          favoriteCount = response["likes"] as int;
        });
      }
    } catch (error) {
      print('Error fetching likes: $error');
    }
  }

  Future<void> _checkIfFavorited() async {
    if (currentUserId != null) {
      final favorites = await FeedService.getFavorites(currentUserId!);
      if (!mounted) return;
      setState(() {
        isTapped = favorites.contains(widget.reviewId);
        countColor = isTapped ? Colors.red : Colors.white;
        iconColor = isTapped ? Colors.red : Colors.white;
      });
    }
  }

  void _subscribeToRealtimeUpdates() {
    _subscription = Supabase.instance.client
        .from('reviews')
        .stream(primaryKey: ['review_id'])
        .eq('review_id', widget.reviewId)
        .listen((data) {
          if (!mounted) return;
          if (data.isNotEmpty && data.first.containsKey("likes")) {
            setState(() {
              favoriteCount = data.first["likes"] as int;
            });
          }
        });
  }

  Future<void> _toggleFavorite() async {
    if (currentUserId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to favorite items')),
      );
      return;
    }

    final previousState = isTapped;
    if (!mounted) return;
    setState(() {
      isTapped = !isTapped;
      favoriteCount = isTapped ? favoriteCount + 1 : favoriteCount - 1;
      countColor = isTapped ? Colors.red : Colors.white;
      iconColor = isTapped ? Colors.red : Colors.white;
    });

    try {
      final success = await Future.wait([
        FeedService.toggleFavorite(currentUserId!, widget.reviewId),
        FeedService.updateLikes(widget.reviewId, favoriteCount),
      ]);

      if (!mounted) return;
      if (!success.every((result) => result)) {
        setState(() {
          isTapped = previousState;
          favoriteCount = isTapped ? favoriteCount + 1 : favoriteCount - 1;
          countColor = isTapped ? Colors.red : Colors.white;
          iconColor = isTapped ? Colors.red : Colors.white;
        });
      }
    } catch (error) {
      print('Error toggling favorite: $error');
      if (!mounted) return;
      setState(() {
        isTapped = previousState;
        favoriteCount = isTapped ? favoriteCount + 1 : favoriteCount - 1;
        countColor = isTapped ? Colors.red : Colors.white;
        iconColor = isTapped ? Colors.red : Colors.white;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double componentWidth = screenWidth * 0.1;

    // Format the favorite count for display
    String formattedCount =
        favoriteCount < 1000
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
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
