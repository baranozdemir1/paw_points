import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'forgot_password_form.dart';

class ForgotPasswordBody extends StatelessWidget {
  const ForgotPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Image.asset(
                'assets/images/forgot_password.png',
                height: getProportionateScreenHeight(300),
                width: getProportionateScreenWidth(275),
              ),
              const Text(
                'Please enter your email and we will send\nyou a link to return to your account',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              const ForgotPasswordForm()
            ],
          ),
        ),
      ),
    );
  }
}
