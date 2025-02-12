import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
import 'package:fiton/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {'id': 1, 'name': 'Bomber Jackets', 'price': "LKR.4800.00", 'size': 'L', 'image': 'assets/images/feed/profile.jpg'},
    {'id': 2, 'name': 'Bomber Jackets', 'price': "LKR.3200.00", 'size': 'M', 'image': 'assets/images/feed/profile.jpg'},
    {'id': 3, 'name': 'Bomber Jackets', 'price': "LKR.2500.OO", 'size': 'XL', 'image': 'assets/images/feed/profile.jpg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Center(
        child: Text('Cart Screen'),
      ),
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
                  'Total: LKR.10,750.00',
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
                  elevation: 5, // Adding elevation for shadow effect
                  color: Colors.white, // Explicitly set card color to white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners for the card
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12), // Adjust padding for better fit
                    child: Row(
                      children: [
                        // Item Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'],
                            width: 70,  // Adjust image size
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Item Details
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
                        // Quantity Controls and Delete Button
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item['size'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black45
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                // Decrease Quantity Button
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.remove_circle_outline_rounded,color:Colors.black54,),
                                  iconSize: 30, // Adjust icon size for better fitting
                                ),
                                SizedBox(width: 8), // Space between buttons
                                Text('1', style: TextStyle(fontSize: 16,color: Colors.black45)),
                                SizedBox(width: 8),
                                // Increase Quantity Button
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.add_circle_outline_rounded,color:Colors.black54,),
                                  iconSize: 30, // Adjust size
                                ),
                              ],
                            ),
                            // Delete Button
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete, color: Colors.red),
                              iconSize: 20, // Adjust icon size
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
                    Text(
                      'Sub total',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text('LKR.10 500.00',
                      style: TextStyle(
                          color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text('LKR.250.00',
                      style: TextStyle(
                        color: Colors.black45
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[900],
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
