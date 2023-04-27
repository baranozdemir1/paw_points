import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/vm/login/login_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          SizedBox(
            height: 300,
          ),
          Center(
            child: Text('Home Screen'),
          ),
          SignOutWidget(),
          SizedBox(
            height: 300,
          ),
        ],
      ),
    );
  }
}

class SignOutWidget extends HookConsumerWidget {
  const SignOutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await ref.read(loginControllerProvider.notifier).signOut();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
