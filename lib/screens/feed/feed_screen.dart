import 'package:flutter/material.dart';
import 'package:fiton/screens/nav/nav_screen.dart';
import 'package:fiton/screens/feed/tryon_screen.dart';
import 'package:fiton/screens/feed/review_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Map<String, String>> cardData = [
    {
      'image': 'lib/cloth_1.jpg',
      'profile': 'lib/cloth_1.jpg',
      'Cus':'lib/cloth_1.jpg',
      'name': 'User1',
      'likes': '1.3K',
      'price': '4 399 Rs',
      'oldPrice': '5 000 Rs [-20%]',
      'description': 'Long Sleeves Crop Top For Girls',
    },
    {
      'image': 'lib/cloth_2.jpeg',
      'profile': 'lib/cloth_2.jpeg',
      'Cus':'lib/cloth_2.jpeg',
      'name': 'User2',
      'likes': '2.5K',
      'price': '3 199 Rs',
      'oldPrice': '4 000 Rs [-10%]',
      'description': 'Trendy Jacket For Men',
    },
    {
      'image': 'lib/cloth_3.jpeg',
      'profile': 'lib/cloth_3.jpeg',
      'Cus':'lib/cloth_3.jpeg',
      'name': 'User3',
      'likes': '3.7K',
      'price': '1 299 Rs',
      'oldPrice': '1 800 Rs [-30%]',
      'description': 'Stylish Sunglasses',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: cardData.length,
              itemBuilder: (context, index) {
                var card = cardData[index];
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < 0) {  // Right swipe
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TryOnScreen(),
                      ));
                    }
                  },
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(card['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Top Navigation Bar
                      Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(card['profile']!),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Column(
                                      children: [
                                        SizedBox(width:1),
                                        IconButton(
                                          icon: Icon(Icons.favorite, color: Colors.red, size: 30),
                                          onPressed: () {
                                            // Add your Cart action here
                                          },
                                        ),
                                        SizedBox(width:1),
                                        Text(
                                          card['likes']!,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(Icons.search_rounded, color: Colors.white, size: 30),
                                  onPressed: () {
                                    // Add your Cart action here
                                  },
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(Icons.bookmark, color: Colors.white, size: 30),
                                  onPressed: () {
                                    // Add your Cart action here
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Centered Icon
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.65,
                        left: MediaQuery.of(context).size.width * 0.25,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.person_add, color: Colors.white, size: 30),
                              onPressed: () {
                                // Add your Add Friend action here
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.shopping_bag, color: Colors.white, size: 40),
                              onPressed: () {
                                // Add your Buy Now action here
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                              onPressed: () {
                                // Add your Cart action here
                              },
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 1,
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                              onPressed: () {
                                // Right Tick Action
                              },
                            ),
                            SizedBox(height: 10),
                            IconButton(
                              icon: Icon(Icons.menu, color: Colors.white, size: 30),
                              onPressed: () {
                                // Menu Button Action
                              },
                            ),
                          ],
                        ),
                      ),

                      // Product Info with Border Box and Avatar
                      Positioned(
                        bottom: 65,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 18),
                                SizedBox(width: 5),
                                Text('4.5', style: TextStyle(color: Colors.white)),
                                SizedBox(width: 10),
                                Text('1.3K reviews', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              card['price']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              card['description']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              card['oldPrice']!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ReviewScreen()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Ensures the button wraps its content
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: AssetImage(card['Cus']!),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Highly Recommended!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavScreen(),
          ),
        ],
      ),
    );
  }
}
