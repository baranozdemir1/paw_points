import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';

import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../riverpod/services/user_state.dart';

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
          press: () {},
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
            await ref.read(authRepositoryProvider).signOut();
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
              color: kPrimaryColor,
            ),
            const SizedBox(width: 20),
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
