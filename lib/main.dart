import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/auth_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oetruvmloogtbbrdjeyc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthNavigator();
  }
}
