import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_points/constants.dart';
import 'package:paw_points/screens/paw/paw_screen.dart';

import 'home/home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  static String routeName = '/';

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentPageIndex = 0;
  Color inActiveIconColor = const Color(0xFFB6B6B6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: newNav(context),
      body: [
        const HomeScreen(),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text(
            'Map Page',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text(
            'Settings Page',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }

  Container newNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15.0,
        left: 60.0,
        right: 60.0,
        bottom: 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = 0;
                });
              },
              icon: Icon(
                CupertinoIcons.paw,
                color:
                    currentPageIndex == 0 ? kPrimaryColor : inActiveIconColor,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: inActiveIconColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -15),
                    blurRadius: 20,
                    color: const Color(0xFFDADADA).withOpacity(0.15),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, PawScreen.routeName);
                },
                icon: const Icon(
                  CupertinoIcons.placemark_fill,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = 2;
                });
              },
              icon: Icon(
                CupertinoIcons.person_fill,
                color:
                    currentPageIndex == 2 ? kPrimaryColor : inActiveIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container oldNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, PawScreen.routeName);
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.paw),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person),
            label: 'Map',
            selectedIcon: Icon(
              CupertinoIcons.person_fill,
              color: kPrimaryColor,
            ),
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person),
            label: 'Map',
            selectedIcon: Icon(
              CupertinoIcons.person_fill,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
