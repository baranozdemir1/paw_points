import 'package:flutter/material.dart';
import 'package:paw_points/screens/paw/components/paw_body.dart';

class PawScreen extends StatelessWidget {
  const PawScreen({super.key});

  static String routeName = '/paw';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paw Points'),
      ),
      body: const PawBody(),
    );
  }
}
