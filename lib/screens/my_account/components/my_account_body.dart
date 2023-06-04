import 'package:flutter/material.dart';
import 'package:paw_points/screens/my_account/components/my_account_form.dart';

import '../../../size_config.dart';

class MyAccountScreenBody extends StatelessWidget {
  const MyAccountScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                const MyAccountScreenForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
