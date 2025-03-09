import 'package:fiton/models/cart_model.dart'; // Import your Cart model
import 'package:fiton/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? cart;
  List<Map<String, dynamic>> cartItems = [];
  double total = 0.0;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  // Fetch cart data from Supabase with join query
  Future<void> fetchCart() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('User not logged in');
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
        final newCart = await _supabase
            .from('carts')
            .insert({'buyer_id': user.id}).select('''
              *, 
              cart_items (*)  // Join cart_items table
            ''').single();

        setState(() {
          cart = Cart.fromJson(newCart);
          cartItems = [];
        });
      } else {
        setState(() {
          cart = Cart.fromJson(cartResponse);
          cartItems = cartItemsFromDatabase(cartResponse['cart_items'] ?? []);
        });
        calculateTotal();
      }
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  // Convert cart items from database to a list of maps
  List<Map<String, dynamic>> cartItemsFromDatabase(List<dynamic> items) {
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
  }

  // Calculate total price
  void calculateTotal() {
    total = cartItems.fold(
      0.0,
      (sum, item) =>
          sum + (double.tryParse(item['price'])! * (item['quantity'] ?? 1)),
    );
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
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Purple Header
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Color (0xFF1B0331),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Cart Items List
          Expanded(
            child: cartItems.isEmpty
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
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
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item['size'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => decreaseQuantity(item),
                                        icon: Icon(
                                            Icons.remove_circle_outline_rounded,
                                            color: Colors.black54),
                                        iconSize: 30,
                                      ),
                                      SizedBox(width: 8),
                                      Text(item['quantity'].toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black45)),
                                      SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () => increaseQuantity(item),
                                        icon: Icon(
                                            Icons.add_circle_outline_rounded,
                                            color: Colors.black54),
                                        iconSize: 30,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () => deleteCartItem(item),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Summary Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
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
                    backgroundColor: Color(0xFF1B0331),
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
      bottomNavigationBar: NavScreen(), // Add bottom navigation bar here
    );
  }
}