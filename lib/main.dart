
// import 'package:fiton/screens/auth/onboarding_screen.dart';
// import 'package:fiton/screens/auth/login_screen.dart';
// import 'package:fiton/screens/auth/login_screen.dart';
import 'package:fiton/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const OnboardingScreen(),
      // home: LoginPage(),
      home: SignUpPage(),
    );
  }
}

