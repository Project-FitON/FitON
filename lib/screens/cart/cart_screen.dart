import 'package:fiton/models/cart_model.dart';
import 'package:fiton/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton/models/cart_items_model.dart';
import 'package:fiton/screens/feed/buy_now_screen.dart'; // Import the BuyNowScreen

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? cart;
  List<CartItems> cartItems = [];
  double total = 0.0;
  final SupabaseClient _supabase = Supabase.instance.client;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      debugPrint('Fetching cart items...');
      final cartItemsResponse = await _supabase
          .from('cart_items')
          .select('*, products (*)');

      if (mounted) {
        setState(() {
          cartItems = cartItemsFromDatabase(cartItemsResponse);
          calculateTotal();
        });
      }
    } catch (e) {
      debugPrint('Error fetching cart items: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<CartItems> cartItemsFromDatabase(List<dynamic> items) {
    return items.map<CartItems>((item) {
      final product = item['products'] ?? {};
      final List<dynamic> images =
          (product['images'] is List) ? product['images'] : [];
      final String imageUrl =
          images.isNotEmpty
              ? images[0]
              : 'https://example.com/tshirt1.jpg'; // Use the first image URL or empty string

      return CartItems(
        cartItemId: item['cart_item_id'] ?? '',
        cartId: item['cart_id'] ?? '',
        productId: item['product_id'] ?? '',
        quantity: item['quantity'] ?? 1,
        selectedSize: item['selected_size'] ?? 'M',
        selectedColor: item['selected_color'] ?? 'No Color',
        createdAt: DateTime.parse(
          item['created_at'] ?? DateTime.now().toIso8601String(),
        ),
        imageUrl: imageUrl, // Use the image URL from the products table
        productName: product['name'] ?? 'Unnamed Product', // Add product name
        productPrice:
            (product['price'] as num?)?.toDouble() ?? 0.0, // Add price
      );
    }).toList();
  }

  void calculateTotal() {
    total = cartItems.fold(0.0, (sum, item) {
      return sum + (item.productPrice * item.quantity); // Use actual price
    });
  }

  void decreaseQuantity(CartItems item) async {
    if (item.quantity > 1) {
      final updatedItem = CartItems(
        cartItemId: item.cartItemId,
        cartId: item.cartId,
        productId: item.productId,
        quantity: item.quantity - 1,
        selectedSize: item.selectedSize,
        selectedColor: item.selectedColor,
        createdAt: item.createdAt,
        imageUrl: item.imageUrl,
        productName: item.productName,
        productPrice: item.productPrice,
      );

      setState(() {
        final index = cartItems.indexOf(item);
        if (index != -1) {
          cartItems[index] = updatedItem;
        }
        calculateTotal();
      });

      await updateCartItem(updatedItem);
    }
  }

  void increaseQuantity(CartItems item) async {
    final updatedItem = CartItems(
      cartItemId: item.cartItemId,
      cartId: item.cartId,
      productId: item.productId,
      quantity: item.quantity + 1,
      selectedSize: item.selectedSize,
      selectedColor: item.selectedColor,
      createdAt: item.createdAt,
      imageUrl: item.imageUrl,
      productName: item.productName,
      productPrice: item.productPrice,
    );

    setState(() {
      final index = cartItems.indexOf(item);
      if (index != -1) {
        cartItems[index] = updatedItem;
      }
      calculateTotal();
    });

    await updateCartItem(updatedItem);
  }

  Future<void> deleteCartItem(CartItems item) async {
    try {
      await _supabase
          .from('cart_items')
          .delete()
          .eq('cart_item_id', item.cartItemId); // Use the correct column name
      if (mounted) {
        setState(() {
          cartItems.removeWhere((i) => i.cartItemId == item.cartItemId);
          calculateTotal();
        });
      }
    } catch (e) {
      debugPrint('Error deleting item: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete item: $e')));
      }
    }
  }

  Future<void> updateCartItem(CartItems item) async {
    try {
      await _supabase
          .from('cart_items')
          .update({'quantity': item.quantity})
          .eq('cart_item_id', item.cartItemId); // Use the correct column name
    } catch (e) {
      debugPrint('Error updating item: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update item: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.purple[900],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16, top: 24, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY CART',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        cartItems.isEmpty
                            ? Center(
                              child: Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                            : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading:
                                        item.imageUrl.isNotEmpty
                                            ? SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.network(
                                                item.imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  // Display a placeholder if the image fails to load
                                                  return Icon(
                                                    Icons.image,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              ),
                                            )
                                            : SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    title: Text(
                                      item.productName,
                                    ), // Show product name
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${item.productPrice.toStringAsFixed(2)} each',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple[900],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text('Size: ${item.selectedSize}'),
                                        Text(
                                          'Quantity: ${item.quantity}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Total: \$${(item.productPrice * item.quantity).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            color: Colors.purple[900],
                                          ),
                                          onPressed:
                                              () => decreaseQuantity(item),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.purple[900],
                                          ),
                                          onPressed:
                                              () => increaseQuantity(item),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red[700],
                                          ),
                                          onPressed: () => deleteCartItem(item),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the BuyNowScreen when the checkout button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CheckoutScreen(
                                  cartItems: cartItems,
                                  total: total,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[900],
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: NavScreen(),
    );
  }
}
