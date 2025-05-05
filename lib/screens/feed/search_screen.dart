import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Search in products
      final productResults = await Supabase.instance.client
          .from('products')
          .select('*, shops(*)')
          .ilike('name', '%$query%')
          .limit(10);

      // Search in shops
      final shopResults = await Supabase.instance.client
          .from('shops')
          .select()
          .ilike('shop_name', '%$query%')
          .limit(5);

      setState(() {
        _searchResults = [
          ...productResults.map((p) => {'type': 'product', ...p}),
          ...shopResults.map((s) => {'type': 'shop', ...s}),
        ];
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search products or shops...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'Inter',
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchResults = []);
                },
              ),
            ),
            onChanged: _performSearch,
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : _searchResults.isEmpty && _searchController.text.isNotEmpty
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
                    Text(
                      'No results found for "${_searchController.text}"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  final isProduct = result['type'] == 'product';
                  final shop = isProduct ? result['shops'] : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // TODO: Navigate to detail screen
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      isProduct
                                          ? (result['images']?[0] ?? '')
                                          : (result['profile_photo'] ?? ''),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        color: Colors.grey[800],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Image.asset(
                                        'assets/images/feed/recommed.jpg',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isProduct
                                          ? result['name'] ?? ''
                                          : result['shop_name'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (isProduct && shop != null) ...[
                                      Text(
                                        shop['shop_name'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    Text(
                                      isProduct
                                          ? '\$${result['price']}'
                                          : '${result['followers'] ?? 0} followers',
                                      style: TextStyle(
                                        color:
                                            isProduct
                                                ? Colors.white
                                                : Colors.grey[400],
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight:
                                            isProduct ? FontWeight.w600 : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
