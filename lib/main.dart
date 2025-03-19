import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/feed/feed_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/fashee/fashee_screen.dart';
import 'screens/account/account_screen.dart';
import 'services/navigation_service.dart';
import 'screens/feed/nav_screen.dart';

void main() async {
  // Add error handling for Flutter initialization
  try {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

    await Supabase.initialize(
      url: 'https://oetruvmloogtbbrdjeyc.supabase.co', // Replace with your Supabase URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o', // Replace with your Supabase anon key
    );

    // Run the app inside error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
    };

    runApp(FitOn());
  } catch (e, stackTrace) {
    print('Error during app initialization: $e');
    print('Stack trace: $stackTrace');
    // Run a minimal app that displays the error
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing app: $e'),
        ),
      ),
    ));
  }
}

class FitOn extends StatelessWidget {
  const FitOn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitON',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigationService.navigatorKey,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        print('Generating route: ${settings.name}');
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => OnboardingScreen());
          case NavigationService.feedRoute:
            return MaterialPageRoute(builder: (context) => FeedScreen());
          case NavigationService.cartRoute:
            return MaterialPageRoute(builder: (context) => CartScreen());
          case NavigationService.fasheeRoute:
            return MaterialPageRoute(builder: (context) => FasheeScreen());
          case NavigationService.profileRoute:
            return MaterialPageRoute(builder: (context) => AccountScreen());
          default:
            return MaterialPageRoute(builder: (context) => OnboardingScreen());
        }
      },
    );
  }
}
