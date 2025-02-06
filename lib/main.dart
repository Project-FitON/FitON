import 'package:fiton/screens/cart/cart_screen.dart'; // Importing CartScreen
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Ensure that Flutter binding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your Supabase URL and anon key
  await Supabase.initialize(
    url: 'https://oetruvmloogtbbrdjeyc.supabase.co', // Your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o', // Your Supabase anon key
  );

  runApp(const FitOn());
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
      home: CartScreen(), // Displaying CartScreen as the home screen
    );
  }
}
