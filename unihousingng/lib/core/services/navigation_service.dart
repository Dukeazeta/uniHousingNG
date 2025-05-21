import 'package:flutter/material.dart';

class NavigationService {
  // Singleton pattern
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // Global key for navigator
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get navigator state
  NavigatorState? get navigator => navigatorKey.currentState;

  // Navigate to named route
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigator!.pushNamed(routeName, arguments: arguments);
  }

  // Navigate to named route and remove all previous routes
  Future<dynamic> navigateToAndRemoveUntil(String routeName, {Object? arguments}) {
    return navigator!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  // Navigate to named route and replace current route
  Future<dynamic> navigateToAndReplace(String routeName, {Object? arguments}) {
    return navigator!.pushReplacementNamed(routeName, arguments: arguments);
  }

  // Go back
  void goBack() {
    return navigator!.pop();
  }

  // Go back with result
  void goBackWithResult(dynamic result) {
    return navigator!.pop(result);
  }

  // Go back to specific route
  void goBackToRoute(String routeName) {
    return navigator!.popUntil(ModalRoute.withName(routeName));
  }
}
