import 'package:flutter/material.dart';
import '../../screens/login/components/login_body.dart';
import '../../size_config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const LoginBody(),
    );
  }
}
