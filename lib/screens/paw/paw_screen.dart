import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PawScreen extends StatelessWidget {
  const PawScreen({super.key});

  static String routeName = '/paw';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(CupertinoIcons.left_chevron),
            ),
          ),
        ],
      ),
    );
  }
}
