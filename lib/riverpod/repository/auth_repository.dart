import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    String phoneNumber,
    File profilePath,
  ) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final Reference storageReference = FirebaseStorage.instance.ref();

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uniqueFileName =
          result.user?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

      final Reference storageProfilePicturesDir =
          storageReference.child('profilePictures');
      final Reference storageProfilePictureUpload =
          storageProfilePicturesDir.child(uniqueFileName);

      await storageProfilePictureUpload.putFile(profilePath);

      final photoURL = await storageProfilePictureUpload.getDownloadURL();

      final user = <String, dynamic>{
        'uid': result.user?.uid,
        'email': result.user?.email,
        'displayName': result.user?.displayName ?? displayName,
        'phoneNumber': result.user?.phoneNumber ?? phoneNumber,
        'photoURL': result.user?.photoURL ?? photoURL
      };
      await firebaseFirestore
          .collection('users')
          .doc(result.user?.uid)
          .set(user)
          .onError(
            (error, stackTrace) => print('Error writing document: $error'),
          )
          .whenComplete(
            () => print('Added user'),
          );
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
