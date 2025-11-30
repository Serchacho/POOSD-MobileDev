import 'package:flutter/material.dart';
import 'package:mobile_demo_app/screens/LoginScreen.dart';
import 'package:mobile_demo_app/screens/CardsScreen.dart';
import 'package:mobile_demo_app/screens/CartScreen.dart';
import 'package:mobile_demo_app/screens/ListsScreen.dart';
import 'package:mobile_demo_app/screens/HomePageScreen.dart';
import 'package:mobile_demo_app/screens/SignUpScreen.dart';
import 'package:mobile_demo_app/screens/SignInScreen.dart';
import 'package:mobile_demo_app/screens/ForgotPasswordScreen.dart';
import 'package:mobile_demo_app/screens/MyListsScreen.dart';
import 'package:mobile_demo_app/screens/JoinListScreen.dart';
import 'package:mobile_demo_app/screens/CreateNewListScreen.dart';
import 'package:mobile_demo_app/screens/EditListScreen.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARDSSCREEN = '/cards';
  static const String CARTSCREEN = '/cart';
  static const String LISTSSCREEN = '/lists';
  static const String HOMESCREEN = '/home';
  static const String SIGNUPSCREEN = '/signUp';
  static const String SIGNINSCREEN = '/signIn';
  static const String FORGOTPASSWORDSCREEN = '/forgotPassword';
  static const String MYLISTSSCREEN = '/myLists';
  static const String JOINLISTSCREEN = '/joinList';
  static const String CREATELISTSCREEN = '/createList';
  static const String EDITLISTSCREEN = '/editList';

  // Define routes for pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => LoginScreen(),
    LOGINSCREEN: (context) => LoginScreen(),
    CARDSSCREEN: (context) => CardsScreen(),
    CARTSCREEN: (context) => CartScreen(),
    LISTSSCREEN: (context) => ListsScreen(),
    HOMESCREEN: (context) => const HomePageScreen(),
    SIGNUPSCREEN: (context) => const SignUpScreen(),
    SIGNINSCREEN: (context) => const SignInScreen(),
    FORGOTPASSWORDSCREEN: (context) => const ForgotPasswordScreen(),
    MYLISTSSCREEN: (context) => const MyListsScreen(),
    JOINLISTSCREEN: (context) => const JoinListScreen(),
    CREATELISTSCREEN: (context) => const CreateNewListScreen(),
    EDITLISTSCREEN: (context) => const EditListScreen(),
  };
}