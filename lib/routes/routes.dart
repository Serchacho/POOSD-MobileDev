import 'package:flutter/material.dart';
import 'package:mobile_demo_app/screens/LoginScreen.dart';
import 'package:mobile_demo_app/screens/CardsScreen.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARDSSCREEN = '/cards';

  // Define routes for pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => LoginScreen(),
    LOGINSCREEN: (context) => LoginScreen(),
    CARDSSCREEN: (context) => CardsScreen(),
  };
}
