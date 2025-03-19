import 'package:fiton/screens/fashee/fashee_chat_screen.dart';
import 'package:fiton/screens/feed/nav_screen.dart';
import 'package:flutter/material.dart';

class FasheeHomePage extends StatelessWidget {
  FasheeHomePage({super.key});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
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
                  Positioned(
                    top: screenHeight * 0.02,
                    left: screenWidth * 0.05,
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.black, size: screenWidth * 0.1),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: screenWidth * 0.5,
                    right: 0,
                    child: Container(
                      height: screenHeight * 0.15,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 26, 5, 63),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.05, right: screenWidth * 0.05),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Fashee here,\nNimasha !!!',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.3,
                          child: Image.asset(
                            "assets/images/feed/mmmm.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "Let's explore the fashion...",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                    decoration: InputDecoration(
                                      hintText: 'Ask Me Anything...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(screenWidth * 0.02),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 26, 5, 63),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.send, color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChatScreen()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Wrap(
                          spacing: screenWidth * 0.02,
                          runSpacing: screenHeight * 0.01,
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
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavScreen(),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const CustomButton({super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 15),
      ),
      onPressed: () {
        controller.text = text;
      },
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}