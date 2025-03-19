import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  NavigatorState? get navigator => navigatorKey.currentState;

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    try {
      if (navigator == null) {
        print('Navigator is null when trying to navigate to $routeName');
        return Future.value(false);
      }
      
      print('Navigating to: $routeName');
      return navigator!.pushNamed(routeName, arguments: arguments);
    } catch (e) {
      print('Navigation error when navigating to $routeName: $e');
      return Future.value(false);
    }
  }

  Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
    try {
      if (navigator == null) {
        print('Navigator is null when trying to navigate to $routeName with replacement');
        return Future.value(false);
      }
      
      print('Navigating to with replacement: $routeName');
      return navigator!.pushReplacementNamed(routeName, arguments: arguments);
    } catch (e) {
      print('Navigation error when navigating to $routeName with replacement: $e');
      return Future.value(false);
    }
  }

  void goBack() {
    try {
      if (navigator != null && navigator!.canPop()) {
        print('Going back (pop)');
        navigator!.pop();
      } else {
        print('Cannot go back - no routes to pop');
      }
    } catch (e) {
      print('Error going back: $e');
    }
  }
  
  // Map screens to their route names for easier reference
  static const String feedRoute = '/feed';
  static const String cartRoute = '/cart';
  static const String fasheeRoute = '/fashee';
  static const String profileRoute = '/profile';
}

// Global instance
final navigationService = NavigationService(); 