import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/riverpod/services/user_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    print(user);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          const Center(
            child: Text('Home Screen'),
          ),
          Text(user?.displayName ?? ''),
          const SizedBox(
            height: 300,
          ),
        ],
      ),
    );
  }
}
