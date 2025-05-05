import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton/screens/feed/feed_screen.dart';
import '../../services/auth_service.dart';
import 'signup_name_screen.dart';

class SignUpOtpScreen extends StatefulWidget {
  final String buyerId;
  final String nickname;
  final String gender;
  final DateTime birthday;
  final List<String> interests;
  final String email;

  const SignUpOtpScreen({
    super.key,
    required this.buyerId,
    required this.nickname,
    required this.gender,
    required this.birthday,
    required this.interests,
    required this.email,
  });

  @override
  State<SignUpOtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<SignUpOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  final int _timerSeconds = 59;
  int _remainingSeconds = 59;
  late Timer _timer;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    print("Email used for OTP: ${widget.email}");
    for (var i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
    _startTimer(); // Start the timer
    _sendOTP(); // Send OTP automatically when the screen loads
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void _onOTPDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _sendOTP() async {
    try {
      await AuthService.signUpWithOTP(widget.email);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send OTP. Please try again.';
      });
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _controllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await AuthService.verifyOTP(
        widget.email,
        otp,
        isSignUp: true,
      );
      if (response.session != null && response.user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SignUpNameScreen(
                    buyerId: response.user!.id,
                    email: widget.email,
                  ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to verify OTP. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/auth/sign-up.png').image,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Blur Circle
                Positioned(
                  top: 300,
                  left: -175,
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        width: 631.72,
                        height: 631.72,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/auth/blur-cir.png',
                          fit: BoxFit.cover,
                        ),
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
                      colors: [Color(0x001B0331), Colors.black],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 55),
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
                                  Text(
                                    'Here we go\n${widget.nickname} !!!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      bottom: 10,
                                    ),
                                    child: Image.asset(
                                      'assets/images/auth/bot.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Please type the OTP I sent to u...',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (index) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  _focusNodes[index].hasFocus
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onChanged:
                                  (value) => _onOTPDigitChanged(index, value),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B0331),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          minimumSize: const Size(319, 49),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Done',
                                      style: TextStyle(
                                        color: Color(0xFFFAFBFC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFFFAFBFC),
                                    ),
                                  ],
                                ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not received? Please wait ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '0:${_remainingSeconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      if (_remainingSeconds == 0)
                        TextButton(
                          onPressed: _sendOTP,
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
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
