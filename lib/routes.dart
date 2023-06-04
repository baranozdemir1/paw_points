import 'package:flutter/material.dart';
import 'package:paw_points/screens/complete_profile/complete_profile_screen.dart';
import 'package:paw_points/screens/forgot_password/forgot_password_screen.dart';
import 'package:paw_points/screens/paw/paw_screen.dart';
import 'package:paw_points/screens/register/register_screen.dart';
import 'package:paw_points/screens/splash/splash_screen.dart';

import 'screens/login/login_screen.dart';
import 'screens/root_screen.dart';

final Map<String, WidgetBuilder> loggedInRoutes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  PawScreen.routeName: (context) => const PawScreen(),
  RootScreen.routeName: (context) => const RootScreen(),
};

final Map<String, WidgetBuilder> loggedOutRoutes = {
  PawScreen.routeName: (context) => const PawScreen(),
  RootScreen.routeName: (context) => const RootScreen(),
};
