import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';
import 'package:paw_points/screens/login/login_screen.dart';
import 'package:paw_points/screens/my_account/my_account.dart';

import '../../../constants.dart';
import '../../../riverpod/services/user_state.dart';
import '../../../size_config.dart';

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);

    return Column(
      children: [
        const SizedBox(height: 20),
        ProfilePicture(userPic: user!.photoURL),
        const SizedBox(height: 20),
        Text(
          'Merhaba ${user.displayName}!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        ProfileMenu(
          text: 'My Account',
          icon: CupertinoIcons.person,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyAccountScreen(),
              ),
            );
          },
        ),
        ProfileMenu(
          text: 'Notification',
          icon: CupertinoIcons.bell,
          press: () {},
        ),
        ProfileMenu(
          text: 'Settings',
          icon: CupertinoIcons.settings,
          press: () {},
        ),
        ProfileMenu(
          text: 'Help Center',
          icon: CupertinoIcons.question,
          press: () {},
        ),
        ProfileMenu(
          text: 'Logout',
          icon: CupertinoIcons.square_arrow_right,
          press: () async {
            ref.read(authRepositoryProvider).signOut().then(
                  (_) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  ),
                );
          },
        ),
      ],
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    required this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(10),
      ),
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(getProportionateScreenWidth(18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              getProportionateScreenWidth(15),
            ),
          ),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: getProportionateScreenWidth(25),
              color: kPrimaryColor,
            ),
            SizedBox(width: getProportionateScreenWidth(30)),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Icon(CupertinoIcons.right_chevron)
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.userPic,
  });

  final String userPic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      height: 115,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(userPic.toString()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
