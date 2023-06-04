import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/user_model.dart';
import '../providers/firebase_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ProviderRef<AuthRepository> ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
    storage: ref.read(storageProvider),
  ),
);

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.read(authRepositoryProvider).authStateChange,
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorage _storage;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _storage = storage;

  CollectionReference get _users => _firestore.collection('users');

  Reference get _storageRef => _storage.ref();

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          displayName: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          photoURL: userCredential.user!.photoURL ?? '',
          uid: userCredential.user!.uid,
          registeredType: 'google',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return userModel;
    } on FirebaseException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = await getUserData(userCredential.user!.uid).first;

      return userModel;
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
    return null;
  }

  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        displayName: '',
        email: email,
        phoneNumber: '',
        photoURL: '',
        uid: user.user!.uid,
        registeredType: 'email',
      );
      await _users.doc(user.user!.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return null;
    } catch (e) {
      if (e == 'email-already-in-use') {
        print('Email already in use.');
      } else {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<UserModel?> updateUserProfile(
    String uid,
    String displayName,
    String phoneNumber,
    File profilePath,
    BuildContext context,
  ) async {
    try {
      final Reference storageProfilePicturesDir =
          _storageRef.child('profilePictures');
      final Reference storageProfilePictureUpload =
          storageProfilePicturesDir.child(uid);

      await storageProfilePictureUpload.putFile(profilePath);

      final photoURL = await storageProfilePictureUpload.getDownloadURL();
      print('photoURL $photoURL');

      await _users.doc(uid).update({
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL
      });

      UserModel userModel = await getUserData(uid).first;

      return userModel;
    } on FirebaseException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
