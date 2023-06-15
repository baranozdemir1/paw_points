import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_points/constants.dart';

import '../../size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawPoints'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: SvgPicture.asset(
          //     'assets/icons/catdog.svg',
          //     height: getProportionateScreenWidth(60),
          //     colorFilter: const ColorFilter.mode(
          //       kPrimaryColor,
          //       BlendMode.srcIn,
          //     ),
          //   ),
          // ),
          Center(
            child: Image.asset(
              'assets/images/catdog-illustration.png',
              height: getProportionateScreenHeight(250),
              width: getProportionateScreenWidth(300),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Welcome to Paw Points!',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(100)),
        ],
      ),
    );
  }
}
