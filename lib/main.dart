import 'package:flutter/material.dart';
import 'screens/auth/onboarding_screen.dart';

void main() {
  runApp(const FitOnApp());
}

class FitOnApp extends StatelessWidget {
  const FitOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: OnboardingScreen(),
        ),
    );
  }
}



