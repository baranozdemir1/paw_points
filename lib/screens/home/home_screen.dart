import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';
import 'package:paw_points/riverpod/services/user_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
          ElevatedButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
              child: Text('logout')),
          Text(user?.displayName ?? ''),
          const SizedBox(
            height: 50,
          ),
          QrImageView(
            data: '1234567890',
            version: QrVersions.auto,
            size: 200.0,
          ),
        ],
      ),
    );
  }
}
