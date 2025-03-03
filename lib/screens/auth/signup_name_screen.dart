import 'dart:ui';
import 'signup_birthday_screen.dart';
import 'package:flutter/material.dart';

class SignUpNameScreen extends StatefulWidget {
  final String buyerId;
  const SignUpNameScreen({super.key, required this.buyerId});

  @override
  _SignUpNameScreenState createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGender;
  late String buyerId;

  @override
  void initState() {
    super.initState();
    buyerId = widget.buyerId;
    _selectedGender = 'female'; // Default gender selection
  }

  void _handleSubmission() {
    if (_nameController.text.isEmpty || _selectedGender == null) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignUpBirthdayScreen(
          buyerId: buyerId,
          nickname: _nameController.text,
          gender: _selectedGender!,
        ),
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
  }

  Widget _buildGenderButton(String text, String value) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        width: 125,
        height: 33.57,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x33C4C4C4) : const Color(0x0D000000),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color(0x09995959),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF959595),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/auth/sign-up-n.jpg').image,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 250,
                  left: -175,
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        width: 631.72,
                        height: 631.72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/auth/blur-cir.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),

                // Gradient Overlay
                Container(
                  decoration: const BoxDecoration(
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Hi !\nI\'m Fashee...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                                    child: Image.asset('assets/images/auth/bot.png', width: 50, height: 50),
                                  ),
                                ],
                              ),
                              const Text(
                                'Love to know about u...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nick Name',
                          labelStyle: TextStyle(
                            color: Color(0xFF959595),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -0.19,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF959595),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 27),
                      Row(
                        children: [
                          _buildGenderButton('🚹 Male', 'male'),
                          const SizedBox(width: 27),
                          _buildGenderButton('🚺 Female', 'female'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _handleSubmission,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B0331),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          minimumSize: const Size(324, 49),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hello Fashee',
                              style: TextStyle(
                                color: Color(0xFFFAFBFC),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Color(0xFFFAFBFC)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
