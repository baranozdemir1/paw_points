import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_points/screens/home/home_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final NavigationBarThemeData navigationBarTheme =
        NavigationBarTheme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(CupertinoIcons.home), label: 'Home'),
          NavigationDestination(icon: Icon(CupertinoIcons.paw), label: 'Map'),
          NavigationDestination(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: [
        HomeScreen(),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: Text(
            'Map Page',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            'Settings Page',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}
