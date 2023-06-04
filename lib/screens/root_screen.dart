import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import 'home/home_screen.dart';
import 'paw/paw_screen.dart';
import 'profile/profile_screen.dart';

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
      bottomNavigationBar: bottomNavBar(context),
      body: [
        const HomeScreen(),
        const Spacer(),
        const ProfileScreen(),
      ][currentPageIndex],
    );
  }

  Container bottomNavBar(BuildContext context) {
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
              icon: SvgPicture.asset(
                'assets/icons/paw.svg',
                height: 25,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PawScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.white,
                  size: 30,
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
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
