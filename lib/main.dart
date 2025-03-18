import 'package:fiton/screens/account/notifications_screen.dart';
import 'package:fiton/screens/add/add_dependents_screen.dart';
import 'package:fiton/screens/add/dependents_screen.dart';
import 'package:fiton/screens/cart/cart_screen.dart';
import 'package:fiton/screens/fashee/fashee_chat_screen.dart';
import 'package:fiton/screens/fashee/fashee_screen.dart';
import 'package:fiton/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/add/dependents_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://oetruvmloogtbbrdjeyc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o',
  );
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
        body: FeedScreen(),
        ),
    );
  }
}