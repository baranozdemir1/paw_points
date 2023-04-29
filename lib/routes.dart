import 'package:flutter/material.dart';
import 'package:paw_points/auth_checker.dart';
import 'package:paw_points/screens/complete_profile/complete_profile_screen.dart';
import 'package:paw_points/screens/forgot_password/forgot_password_screen.dart';
import 'package:paw_points/screens/home/home_screen.dart';
import 'package:paw_points/screens/paw/paw_screen.dart';
import 'package:paw_points/screens/profile/profile_screen.dart';
import 'package:paw_points/screens/root_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  AuthChecker.routeName: (context) => const AuthChecker(),
  SplashScreen.routeName: (context) => const AuthChecker(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  PawScreen.routeName: (context) => const PawScreen(),
  RootScreen.routeName: (context) => const RootScreen(),
};
