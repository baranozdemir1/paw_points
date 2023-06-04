import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/complete_profile_body.dart';

class CompleteProfileScreen extends ConsumerWidget {
  const CompleteProfileScreen({super.key});

  static String routeName = '/complete_profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Complete Profile'),
            automaticallyImplyLeading: false,
          ),
          body: const CompleteProfileBody(
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
