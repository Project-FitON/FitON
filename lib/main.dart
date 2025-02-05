import 'package:fiton/screens/cart/cart_screen.dart';
import 'package:fiton/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/feed/tryon_screen.dart';

void main() async {
  runApp(FitOn());
}

class FitOn extends StatelessWidget {
  const FitOn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: FeedScreen(),
        ),
    );
  }
}