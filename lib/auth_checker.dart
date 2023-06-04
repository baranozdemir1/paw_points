import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/components/loader.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';
import 'package:paw_points/screens/login/login_screen.dart';
import 'package:paw_points/screens/root_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data) {
        if (data != null) return const RootScreen();
        return const LoginScreen();
      },
      error: (error, trace) => const Dialog(),
      loading: () => const Loader(),
    );
  }
}
