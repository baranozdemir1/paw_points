import 'package:flutter/material.dart';
import 'package:paw_points/screens/my_account/components/my_account_body.dart';

import '../../size_config.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: const MyAccountScreenBody(),
    );
  }
}
