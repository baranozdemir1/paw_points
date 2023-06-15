import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/models/user_model.dart';
import 'package:paw_points/riverpod/repository/auth_repository.dart';

final userStateProvider = StateNotifierProvider<UserState, UserModel?>(
  (ref) => UserState(ref),
);

class UserState extends StateNotifier<UserModel?> {
  UserState(this.ref) : super(null) {
    ref.watch(authRepositoryProvider).authStateChange.listen(
      (User? user) async {
        if (user != null) {
          final userDoc =
              await _firestore.collection('users').doc(user.uid).get();
          final userModel = UserModel(
            displayName: userDoc['displayName'],
            email: userDoc['email'],
            phoneNumber: userDoc['phoneNumber'],
            photoURL: userDoc['photoURL'],
            uid: user.uid,
            registeredType: userDoc['registeredType'],
          );
          state = userModel;
          _currentUser = userModel;
        } else {
          state = null;
        }
      },
    );
  }

  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;

  Future<UserModel?> getCurrentUser() async {
    if (_currentUser == null) {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        _currentUser = UserModel(
          displayName: userDoc['displayName'],
          email: userDoc['email'],
          phoneNumber: userDoc['phoneNumber'],
          photoURL: userDoc['photoURL'],
          uid: user.uid,
          registeredType: userDoc['registeredType'],
        );
      }
    }
    return _currentUser;
  }

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserModel? user = await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password, context);

      state = user;
    } catch (e) {
      print('user state error: $e');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      UserModel? user =
          await ref.read(authRepositoryProvider).signInWithGoogle(context);

      state = user;
    } catch (e) {
      print('eeeerrr : $e');
    }
  }

  Future<void> register(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserModel? user = await ref
          .read(authRepositoryProvider)
          .registerWithEmailAndPassword(email, password, context);

      state = user;
    } catch (e) {
      print('register: $e');
    }
  }

  Future<void> completeProfile(
    String uid,
    String displayName,
    String phoneNumber,
    File? profilePath,
    BuildContext context,
  ) async {
    try {
      UserModel? user = await ref.read(authRepositoryProvider).completeProfile(
            uid,
            displayName,
            phoneNumber,
            profilePath,
            context,
          );

      state = user;
    } catch (e) {
      print('complete profile : $e');
    }
  }
}
