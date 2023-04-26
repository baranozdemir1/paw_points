import 'package:flutter/material.dart';
import 'package:paw_points/screens/login/login_screen.dart';
import 'package:paw_points/screens/login_success/login_success_screen.dart';
import 'package:paw_points/screens/register/register_screen.dart';
import 'package:paw_points/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
};
