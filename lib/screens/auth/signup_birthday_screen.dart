import 'dart:ui';
import 'signup_otp_screen.dart';
import 'package:flutter/material.dart';

class SignUpBirthdayScreen extends StatefulWidget {
  final String buyerId;
  final String nickname;
  final String gender;

  const SignUpBirthdayScreen({
    super.key,
    required this.buyerId,
    required this.nickname,
    required this.gender,
  });

  @override
  _SignUpBirthdayScreenState createState() => _SignUpBirthdayScreenState();
}

class _SignUpBirthdayScreenState extends State<SignUpBirthdayScreen> {
  DateTime now = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  void _handleSubmission() {
    final birthday = DateTime(selectedYear, selectedMonth, selectedDay);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignUpOtpScreen(
          buyerId: widget.buyerId,
          nickname: widget.nickname,
          gender: widget.gender,
          birthday: birthday,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/images/auth/sign-up-b.jpg').image,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 275,
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
                  stops: [0.0, 0.9998],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Hello\n${widget.nickname}..!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, bottom: 10),
                                child: Image.asset('assets/images/auth/bot.png', width: 50, height: 50),
                              ),
                            ],
                          ),
                          const Text(
                            'Can I know your BIRTHDAY?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPicker(
                          List.generate(2025 - 1950 + 1, (i) => 1950 + i),
                          (value) => setState(() => selectedYear = value),
                          selectedYear,
                        ),
                        _buildPicker(
                          List.generate(12, (i) => i + 1),
                          (value) => setState(() => selectedMonth = value),
                          selectedMonth,
                        ),
                        _buildPicker(
                          List.generate(31, (i) => i + 1),
                          (value) => setState(() => selectedDay = value),
                          selectedDay,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          'You got it',
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
    );
  }

  Widget _buildPicker(List<int> items, Function(int) onSelected, int selected) {
    return SizedBox(
      width: 100,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 30,
        diameterRatio: 1.5,
        useMagnifier: true,
        magnification: 1.2,
        onSelectedItemChanged: (index) => onSelected(items[index]),
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: items.indexOf(selected)),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                items[index].toString().padLeft(2, '0'),
                style: TextStyle(
                  color: const Color(0xFF959595),
                  fontSize: 20,
                  fontWeight: items[index] == selected ? FontWeight.w300 : FontWeight.w100,
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
