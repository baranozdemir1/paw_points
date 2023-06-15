import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/components/paw_points_loader.dart';
import 'package:paw_points/screens/paw/components/paw_body.dart';
import 'package:paw_points/size_config.dart';

import '../../models/user_model.dart';
import '../../riverpod/services/user_state.dart';

class PawScreen extends ConsumerWidget {
  const PawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paw Points'),
      ),
      body: FutureBuilder<UserModel?>(
        future: ref.watch(userStateProvider.notifier).getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PawPointsLoader();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text('User not found'),
            );
          } else {
            return const PawBody();
          }
        },
      ),
    );
  }
}
