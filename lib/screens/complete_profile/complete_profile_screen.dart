import 'package:flutter/material.dart';

import 'components/complete_profile_body.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  static String routeName = '/complete_profile';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
      ),
      body: CompleteProfileBody(
        email: args['email'] ?? '',
        password: args['password'] ?? '',
      ),
    );
  }
}
