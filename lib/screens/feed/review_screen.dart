import 'package:flutter/material.dart';
import 'package:fiton/screens/nav/nav_screen.dart'; // Ensure correct import path

class ReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "John Doe",
      "avatar": "assets/avatar1.png",
      "review": "Great service! Highly recommend.",
      "likes": 15,
      "comments": 3,
      "images": ["assets/review1.png"]
    },
    {
      "name": "Jane Smith",
      "avatar": "assets/avatar2.png",
      "review": "Amazing experience, will come back again.",
      "likes": 20,
      "comments": 5,
      "images": []
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Reviews")),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(review["avatar"]!),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        review["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(review["review"]!),
                  if (review["images"].isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: review["images"].map<Widget>((img) {
                          return Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Image.asset(img, width: 100, height: 100),
                          );
                        }).toList(),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () {},
                          ),
                          Text("${review["likes"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {},
                          ),
                          Text("${review["comments"]}"),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavScreen()),
          );
        },
        child: Icon(Icons.arrow_back),
      ),

    );
  }
}
