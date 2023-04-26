import 'package:flutter/material.dart';
import 'package:paw_points/screens/splash/components/splash_body.dart';
import 'package:paw_points/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: SplashBody(),
    );
  }
}
