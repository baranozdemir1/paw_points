import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';
import 'package:paw_points/riverpod/services/user_state.dart';

import '../../../components/paw_points_loader.dart';
import '../../../components/no_account_text.dart';
import '../../../components/social_card.dart';
import '../../../screens/login/components/login_form.dart';
import '../../../size_config.dart';

class LoginBody extends ConsumerStatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends ConsumerState<LoginBody> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    loading() {
      setState(() {
        isLoading = !isLoading;
      });
    }

    final auth = ref.watch(authRepositoryProvider);

    return SafeArea(
      child: isLoading
          ? const PawPointsLoader()
          : SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Login with your email and password \nor continue with social media',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      const LoginForm(),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialCard(
                            icon: 'assets/icons/google-icon.svg',
                            press: () async {
                              loading();
                              await ref
                                  .read(userStateProvider.notifier)
                                  .signInWithGoogle(context)
                                  .whenComplete(
                                    () => auth.authStateChange.listen(
                                      (event) async {
                                        if (event == null) {
                                          loading();
                                          return;
                                        }
                                      },
                                    ),
                                  );
                            },
                          ),
                          SocialCard(
                            icon: 'assets/icons/facebook-2.svg',
                            press: () {},
                          ),
                          SocialCard(
                            icon: 'assets/icons/twitter.svg',
                            press: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      const NoAccountText()
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
