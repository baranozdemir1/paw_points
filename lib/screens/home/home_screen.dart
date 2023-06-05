import 'package:flutter/material.dart';
import 'package:paw_points/components/location_report.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR'),
      ),
      body: ElevatedButton(
        child: Text('click'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LocationReport(),
              settings: RouteSettings(
                arguments: ReportArguments(
                  'markerId',
                  latitude: 35.00,
                  longitude: 27.00,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
