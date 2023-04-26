import 'package:flutter/material.dart';
import 'package:paw_points/screens/login_success/components/login_success_body.dart';
import 'package:paw_points/size_config.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({Key? key}) : super(key: key);

  static String routeName = '/loginSuccess';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Login Success'),
      ),
      body: const LoginSuccessBody(),
    );
  }
}
