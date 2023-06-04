import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/auth_checker.dart';
import 'package:paw_points/components/loader.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';
import 'package:paw_points/screens/root_screen.dart';

import 'routes.dart';
import 'theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // return MaterialApp(
    //   theme: theme(),
    //   initialRoute: RootScreen.routeName,
    //   routes: authState.when(
    //     data: (data) {
    //       if (data != null) return loggedInRoutes;
    //       return loggedOutRoutes;
    //     },
    //     error: (error, trace) {
    //       print(error);
    //       return loggedOutRoutes;
    //     },
    //     loading: () => {},
    //   ),
    // );

    return MaterialApp(
      theme: theme(),
      home: authState.when(
        data: (data) {
          return const AuthChecker();
        },
        error: (error, trace) {
          print("error: $error, trace: $trace");
        },
        loading: () => const Loader(),
      ),
    );
  }
}
