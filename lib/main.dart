import 'package:flutter/material.dart';
import 'package:paw_points/routes.dart';
import 'package:paw_points/screens/splash/splash_screen.dart';
import 'package:paw_points/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}