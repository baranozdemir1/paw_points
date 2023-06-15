import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/components/paw_points_loader.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';
import 'package:paw_points/screens/login/login_screen.dart';
import 'package:paw_points/screens/root_screen.dart';
import 'package:paw_points/screens/splash/splash_screen.dart';

import 'helpers/paw_points_helper.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data) {
        if (data != null) return const RootScreen();
        return FutureBuilder<bool>(
          future: PawPointsHelper.shouldShowIntro(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!) {
                return const SplashScreen();
              } else {
                return const LoginScreen();
              }
            } else {
              return const PawPointsLoader();
            }
          },
        );
      },
      error: (error, trace) => const Dialog(),
      loading: () => const PawPointsLoader(),
    );
  }
}
