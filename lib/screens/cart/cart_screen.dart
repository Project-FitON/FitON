import 'package:fiton/models/cart_model.dart'; // Ensure this is your correct Cart model path
import 'package:fiton/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? cart; // Cart instance
  List<Map<String, dynamic>> cartItems = []; // List to hold cart items
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  // Fetch cart data from Supabase
  Future<void> fetchCart() async {
    final response = await Supabase.instance.client
        .from('carts') // Replace with your cart table name
        .select()
        .eq('buyer_id', 'YOUR_BUYER_ID'); // Removed `.execute()`

    if (response.isNotEmpty) {
      setState(() {
        cart = Cart.fromJson(response[0]); // Assuming one cart per buyer
        cartItems =
            cartItemsFromDatabase(response[0]['cart_items']); // Convert items
      });
      calculateTotal();
    } else {
      print('Error fetching cart or cart is empty');
    }
  }

  // Convert the cart items from database to a list of maps
  List<Map<String, dynamic>> cartItemsFromDatabase(List<dynamic> items) {
    return items.map((item) {
      return {
        'id': item['id'], // Assuming each item has an 'id'
        'name': item['name'],
        'price': item['price'],
        'size': item['size'],
        'image': item['image'],
        'quantity': item['quantity'] ?? 1,
      };
    }).toList();
  }

  // Calculate total price
  void calculateTotal() {
    total = cartItems.fold(
        0.0,
        (sum, item) =>
            sum +
            double.parse(item['price']
                    .replaceAll("LKR.", "")
                    .replaceAll(",", "")
                    .trim()) *
                item['quantity']);
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
    final response = await Supabase.instance.client
        .from('cart_items') // Replace with your cart items table name
        .update({'quantity': item['quantity']}).eq(
            'id', item['id']); // Removed `.execute()`

    if (response == null) {
      print('Error updating item');
    }
  }

//Delete cart item
  Future<void> deleteCartItem(Map<String, dynamic> item) async {
    final response = await Supabase.instance.client
        .from('cart_items') // Replace with your cart items table name
        .delete()
        .eq('id', item['id']); // Removed `.execute()`

    if (response != null) {
      setState(() {
        cartItems.remove(item);
        calculateTotal();
      });
    } else {
      print('Error deleting item');
    }
  }

  // Checkout function
  void checkout() {
    // Implement checkout logic here
    print('Checkout with total: LKR. $total');
    // You might want to clear cart or redirect to a payment page
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
                  'Total: LKR. ${total.toStringAsFixed(2)}',
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
            child: ListView.builder(
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
                                '${item['price']} ',
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
                                        fontSize: 16, color: Colors.black45)),
                                SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => increaseQuantity(item),
                                  icon: Icon(Icons.add_circle_outline_rounded,
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
                    Text('LKR. ${total.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.black45)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: TextStyle(color: Colors.black)),
                    Text('LKR.250.00', style: TextStyle(color: Colors.black45)),
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
      bottomNavigationBar: NavScreen(),
    );
  }
}
