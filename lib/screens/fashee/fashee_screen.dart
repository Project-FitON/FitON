import 'package:flutter/material.dart';
import 'package:fiton/screens/fashee/fashee_chat_screen.dart';
import 'package:fiton/screens/feed/feed_screen.dart';
import 'package:fiton/screens/cart/cart_screen.dart';
import 'package:fiton/screens/account/account_screen.dart';

class FasheeScreen extends StatefulWidget {
  const FasheeScreen({Key? key}) : super(key: key);

  @override
  State<FasheeScreen> createState() => _FasheeScreenState();
}

class _FasheeScreenState extends State<FasheeScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 180, 201, 237),
                const Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  // Clickable Menu Button
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.black, size: 40),
                      onPressed: () {
                        print("Menu button clicked!");
                      },
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 180,
                    right: 0,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 26, 5, 63),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 50, right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Fashee here,\nNimasha !!!',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 300,
                          child: Image.asset(
                            "assets/images/feed/mmmm.png",
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.difference,
                          ),
                        ),
                        const Text(
                          "Let's explore the fashion...",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textController,
                                    decoration: const InputDecoration(
                                      hintText: 'Ask Me Anything...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 26, 5, 63),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.send, color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            CustomButton(text: 'I have a wedding', controller: _textController),
                            CustomButton(text: 'Match my clothes', controller: _textController),
                            CustomButton(text: 'Planned to color my hair', controller: _textController),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_outlined, size: 22, color: Colors.black),
                  Text('Feed', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FeedScreen()),
                );
              },
            ),
            IconButton(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.black),
                  Text('Cart', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, size: 45, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.message_outlined, size: 22, color: Colors.red),
                  Text('Fashee', style: TextStyle(fontSize: 12, color: Colors.red)),
                ],
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline, size: 22, color: Colors.black),
                  Text('Profile', style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Button
class CustomButton extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const CustomButton({super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
      onPressed: () {
        controller.text = text;
      },
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}