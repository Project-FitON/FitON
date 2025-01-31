import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> cartItems = [
    CartItem("Bomber Jackets", "L", "assets/jacket 01.png", 4800, 1),
    CartItem("Bomber Jackets", "M", "assets/jacket 02.png", 3200, 1),
    CartItem("Bomber Jackets", "XL", "assets/jacket 03.png", 2500, 1),
  ];

  int get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void updateQuantity(int index, int change) {
    setState(() {
      if (cartItems[index].quantity + change > 0) {
        cartItems[index].quantity += change;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double shipping = 250;
    double total = totalPrice + shipping;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: Column(
        children: [
          _buildHeader(total),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  cartItem: cartItems[index],
                  onQuantityChanged: (change) => updateQuantity(index, change),
                  onRemove: () => removeItem(index),
                );
              },
            ),
          ),
          _buildSummary(totalPrice, shipping, total),
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(double total) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40), // For status bar space
          Text(
            "MY CART",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Total: ${total.toStringAsFixed(0)} Rs",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int subTotal, double shipping, double total) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryRow("Sub total", subTotal),
          _buildSummaryRow("Shipping", shipping),
          Divider(thickness: 1),
          _buildSummaryRow("Total", total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Text(
            "${value.toStringAsFixed(0)} Rs",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Checkout",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.deepPurple.shade900,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "Fashee"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

// Data model for Cart Item
class CartItem {
  final String name;
  final String size;
  final String image;
  final int price;
  int quantity;

  CartItem(this.name, this.size, this.image, this.price, this.quantity);
}

// Widget for displaying each cart item
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  CartItemWidget({
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(cartItem.image, width: 60, height: 60, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.name,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Size: ${cartItem.size}", style: GoogleFonts.poppins(fontSize: 14)),
                  Text("${cartItem.price} Rs", style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () => onQuantityChanged(-1),
                ),
                Text("${cartItem.quantity}", style: GoogleFonts.poppins(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => onQuantityChanged(1),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
