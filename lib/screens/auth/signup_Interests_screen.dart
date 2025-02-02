import 'dart:ui';
import 'login_otp_screen.dart';
import 'package:flutter/material.dart';

class SignUpInterestsScreen extends StatefulWidget {
  @override
  _SignUpInterestsScreenState createState() => _SignUpInterestsScreenState();
}

class _SignUpInterestsScreenState extends State<SignUpInterestsScreen> {
  Set<String> _selectedCategories = {'Casual Wear'};

  final List<Map<String, String>> categories = [
    {'emoji': '💃', 'text': 'Party Wear'},
    {'emoji': '👕', 'text': 'Casual Wear'},
    {'emoji': '👔', 'text': 'Office/Formal Wear'},
    {'emoji': '👓', 'text': 'New Trends'},
    {'emoji': '🥻', 'text': 'Traditional Wear'},
    {'emoji': '👚', 'text': 'Seasonal Wear'},
    {'emoji': '👙', 'text': 'Sleep Wear'},
    {'emoji': '👟', 'text': 'Sports Wear'},
  ];

  Widget _buildCheckbox(String emoji, String text) {
    final isSelected = _selectedCategories.contains(text);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(text);
          } else {
            _selectedCategories.add(text);
          }
        });
      },
      child: Container(
        width: 180,
        height: 33.57,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? Color(0x33C4C4C4) : Color(0x0D000000),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Color(0x99959595),
            width: 1.5,
          ),
        ),
          child: Text(
            '$emoji $text',
            style: TextStyle(
              color: Color(0xFF959595),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/images/auth/sign-up-i.jpg').image,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          // Blur Circle
          children: [
            Positioned( // Blured Circle
              top: 200,
              left: -150,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    width: 631.72,
                    height: 631.72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/auth/blur-cir.png',fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x001B0331),
                  Colors.black,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Bot Messages
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'One last thing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            'Ringing any INTERESTS?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w200,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, top: 33), 
                      child: Image.asset('assets/images/auth/bot.png',width: 50,height: 50),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Checkboxes
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 21.43,
                    crossAxisSpacing: 7,
                    childAspectRatio: 5.4,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCheckbox(
                      categories[index]['emoji']!,
                      categories[index]['text']!,
                    );
                  },
                ),
                SizedBox(height: 20),
                // Button
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LoginOtpScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B0331),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize: const Size.fromHeight(49),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Let's FitOn",
                          style: TextStyle(
                            color: Color(0xFFFAFBFC),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}