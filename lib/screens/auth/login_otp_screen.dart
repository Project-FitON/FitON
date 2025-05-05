import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';

class LoginOTPScreen extends StatefulWidget {
  final String email;

  const LoginOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  _LoginOTPScreenState createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  String _errorMessage = '';
  int _remainingSeconds = 59;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sendOTP();
    _startTimer();
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

  Future<void> _sendOTP() async {
    try {
      await AuthService.signInWithOTP(widget.email);
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
      final response = await AuthService.verifyOTP(widget.email, otp);
      if (response.session != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/feed');
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

  void _onOTPDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Container(
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset('assets/images/auth/log-in-o.jpg').image,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Blur Circle
                  Positioned(
                    top: screenHeight * 0.3,
                    left: -screenWidth * 0.4,
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          width: screenWidth * 1.5,
                          height: screenWidth * 1.5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
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
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        screenHeight * 0.05,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Welcome back\n${widget.email} !!!',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            bottom: 8,
                                          ),
                                          child: Image.asset(
                                            'assets/images/auth/bot.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Please type the OTP I sent...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
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
                                      (value) =>
                                          _onOTPDigitChanged(index, value),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: screenHeight * 0.03),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Let's FitOn",
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
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Not received? Please wait ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              Text(
                                '0:${_remainingSeconds.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          if (_remainingSeconds == 0)
                            TextButton(
                              onPressed: () {
                                _sendOTP();
                                setState(() {
                                  _remainingSeconds = 59;
                                });
                                _startTimer();
                              },
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
