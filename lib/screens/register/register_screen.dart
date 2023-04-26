import 'package:flutter/material.dart';
import 'package:paw_points/screens/register/components/register_body.dart';
import 'package:paw_points/size_config.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const RegisterBody(),
    );
  }
}
