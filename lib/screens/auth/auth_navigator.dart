import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';
import '../feed/feed_screen.dart';
import 'onboarding_screen.dart';
import 'signup_name_screen.dart';
import 'signup_birthday_screen.dart';
import 'signup_Interests_screen.dart';
import 'login_otp_screen.dart';
import 'signup_otp_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/auth',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return MaterialPageRoute(
              builder: (_) => const AuthStateScreen(),
              settings: settings,
            );
          case '/onboarding':
            return MaterialPageRoute(
              builder: (_) => OnboardingScreen(),
              settings: settings,
            );
          case '/login-otp':
            final email = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => LoginOTPScreen(email: email),
              settings: settings,
            );
          case '/signup-otp':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => SignUpOtpScreen(
                    email: args['email'],
                    buyerId: args['buyerId'],
                    nickname: args['nickname'],
                    gender: args['gender'],
                    birthday: args['birthday'],
                    interests: args['interests'],
                  ),
              settings: settings,
            );
          case '/signup-name':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => SignUpNameScreen(
                    buyerId: args['buyerId'],
                    email: args['email'],
                  ),
              settings: settings,
            );
          case '/signup-birthday':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => SignUpBirthdayScreen(
                    buyerId: args['buyerId'],
                    nickname: args['nickname'],
                    gender: args['gender'],
                    email: args['email'],
                  ),
              settings: settings,
            );
          case '/signup-interests':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => SignUpInterestsScreen(
                    buyerId: args['buyerId'],
                    nickname: args['nickname'],
                    gender: args['gender'],
                    birthday: args['birthday'],
                    email: args['email'],
                  ),
              settings: settings,
            );
          case '/feed':
            return MaterialPageRoute(
              builder: (_) => const FeedScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => OnboardingScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session != null) {
            return FutureBuilder<Map<String, dynamic>?>(
              future: AuthService.getUserProfile(session.user.id),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (profileSnapshot.hasData && profileSnapshot.data != null) {
                  return const FeedScreen();
                } else {
                  return FeedScreen(); // return OnboardingScreen();
                }
              },
            );
          }
        }
        return OnboardingScreen();
      },
    );
  }
}
