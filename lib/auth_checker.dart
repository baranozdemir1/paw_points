import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/bottom_navigation.dart';
import 'package:paw_points/screens/home/home_screen.dart';
import 'package:paw_points/screens/splash/splash_screen.dart';

import '../riverpod/providers/auth_provider.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  static const String routeName = '/auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) return const BottomNavigationWidget();
        return const SplashScreen();
      },
      loading: () => const LoadingUI(),
      error: (e, trace) => const SplashScreen(),
    );
  }
}

class LoadingUI extends StatelessWidget {
  const LoadingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
