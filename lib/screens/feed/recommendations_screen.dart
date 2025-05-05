import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<Map<String, dynamic>> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Get user's interests from buyers table
      final buyerData = await Supabase.instance.client
          .from('buyers')
          .select('interests')
          .eq('buyer_id', userId)
          .single();

      final List<dynamic> interests = buyerData['interests'] ?? [];

      // Get products matching user's interests
      if (interests.isNotEmpty) {
        final recommendedProducts = await Supabase.instance.client
            .from('products')
            .select('*, shops(*)')
            .contains('category', interests)
            .order('likes', ascending: false)
            .limit(20);

        setState(() {
          _recommendations = List<Map<String, dynamic>>.from(recommendedProducts);
          _isLoading = false;
        });
      } else {
        // If no interests, show popular products
        final popularProducts = await Supabase.instance.client
            .from('products')
            .select('*, shops(*)')
            .order('likes', ascending: false)
            .limit(20);

        setState(() {
          _recommendations = List<Map<String, dynamic>>.from(popularProducts);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading recommendations: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/feed/back.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recommended for You',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : _recommendations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/feed/recommed.jpg',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No recommendations yet',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Update your interests to get personalized recommendations',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final product = _recommendations[index];
                    final shop = product['shops'];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // TODO: Navigate to product detail
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: product['images']?[0] ?? '',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[800],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/feed/recommed.jpg',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        shop['shop_name'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$${product['price']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
