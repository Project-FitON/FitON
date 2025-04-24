import 'package:fiton/models/cart_model.dart'; // Import your Cart model
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../feed/nav_screen.dart';
import '../feed/feed_components/navigation_component.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? cart;
  List<Map<String, dynamic>> cartItems = [];
  double total = 0.0;
  bool isLoading = true;
  String? errorMessage;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // Use Future.delayed to allow the widget to be mounted before fetching data
    Future.delayed(Duration.zero, () {
      if (mounted) {
        fetchCart();
      }
    });
  }

  // Fetch cart data from Supabase with join query
  Future<void> fetchCart() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final user = _supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'User not logged in';
        });
        return;
      }

      // Debug: Print user ID
      print('Fetching cart for user: ${user.id}');

      // Fetch cart and its items using a join query
      final cartResponse = await _supabase.from('carts').select('''
            *, 
            cart_items (*)  // Join cart_items table
          ''').eq('buyer_id', user.id).maybeSingle();

      // Debug: Print fetched cart data
      print('Fetched cart data: $cartResponse');

      if (cartResponse == null) {
        print('No cart found for user. Creating a new cart...');
        try {
          final newCart = await _supabase
              .from('carts')
              .insert({'buyer_id': user.id}).select('''
                *, 
                cart_items (*)  // Join cart_items table
              ''').single();

          if (mounted) {
            setState(() {
              cart = Cart.fromJson(newCart);
              cartItems = [];
              isLoading = false;
            });
          }
        } catch (e) {
          print('Error creating new cart: $e');
          if (mounted) {
            setState(() {
              isLoading = false;
              errorMessage = 'Error creating new cart: $e';
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            try {
              cart = Cart.fromJson(cartResponse);
              cartItems = cartItemsFromDatabase(cartResponse['cart_items'] ?? []);
              isLoading = false;
            } catch (e) {
              print('Error parsing cart data: $e');
              errorMessage = 'Error parsing cart data: $e';
              isLoading = false;
            }
          });
          calculateTotal();
        }
      }
    } catch (e) {
      print('Error fetching cart: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching cart: $e';
        });
      }
    }
  }

  // Convert cart items from database to a list of maps
  List<Map<String, dynamic>> cartItemsFromDatabase(List<dynamic> items) {
    try {
      return items.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'],
          'name': item['name'] ?? 'Unknown Item',
          'price': item['price']?.toString() ?? '0.00',
          'size': item['size'] ?? 'M',
          'image': item['image'] ?? 'assets/images/placeholder.png',
          'quantity': item['quantity'] ?? 1,
        };
      }).toList();
    } catch (e) {
      print('Error processing cart items: $e');
      return [];
    }
  }

  // Calculate total price
  void calculateTotal() {
    try {
      total = cartItems.fold(
        0.0,
        (sum, item) {
          double price = 0.0;
          try {
            price = double.tryParse(item['price'] ?? '0.0') ?? 0.0;
          } catch (e) {
            print('Error parsing price: $e');
          }
          int quantity = item['quantity'] ?? 1;
          return sum + (price * quantity);
        },
      );
    } catch (e) {
      print('Error calculating total: $e');
      total = 0.0;
    }
  }

  // Increase item quantity
  void increaseQuantity(Map<String, dynamic> item) {
    setState(() {
      item['quantity']++;
      calculateTotal();
    });
    updateCartItem(item);
  }

  // Decrease item quantity
  void decreaseQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] > 1) item['quantity']--;
      calculateTotal();
    });
    updateCartItem(item);
  }

  // Update cart item in Supabase
  Future<void> updateCartItem(Map<String, dynamic> item) async {
    try {
      await _supabase
          .from('cart_items')
          .update({'quantity': item['quantity']}).eq('id', item['id']);

      // Refresh cart data after update
      await fetchCart();
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  // Delete cart item
  Future<void> deleteCartItem(Map<String, dynamic> item) async {
    try {
      await _supabase.from('cart_items').delete().eq('id', item['id']);

      setState(() {
        cartItems.removeWhere((i) => i['id'] == item['id']);
      });
      calculateTotal();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  // Checkout function
  void checkout() {
    print('Checkout with total: \$${total.toStringAsFixed(2)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.purple[900],
      ),
      body: Stack(
        children: [
          // Main content with bottom padding for navigation
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // Cart Items List
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : cartItems.isEmpty
                          ? Center(
                              child: Text(
                                errorMessage ?? 'Your cart is empty',
                                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.fromLTRB(16, 10, 16, 80), // Added bottom padding
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return CartItemCard(
                                  item: item,
                                  onDecrease: () => decreaseQuantity(item),
                                  onIncrease: () => increaseQuantity(item),
                                  onDelete: () => deleteCartItem(item),
                                );
                              },
                            ),
                ),
                // Summary Section
                Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 76), // Added bottom padding for navigation
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sub total', style: TextStyle(color: Colors.black)),
                          Text('\$${total.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping', style: TextStyle(color: Colors.black)),
                          Text('\$5.00', style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[900],
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Navigation component at the bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigationComponent(),
          ),
        ],
      ),
    );
  }
}

// Helper widget for cart items
class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${item['price']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['size'],
                  style: TextStyle(fontSize: 18, color: Colors.black45),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: Icon(Icons.remove_circle_outline_rounded, color: Colors.black54),
                      iconSize: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      item['quantity'].toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: onIncrease,
                      icon: Icon(Icons.add_circle_outline_rounded, color: Colors.black54),
                      iconSize: 30,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: Colors.red),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}