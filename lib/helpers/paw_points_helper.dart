import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PawPoinsHelper {
  static Future<File> copyAssetToFile(String assetPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = assetPath.split('/').last;
    String tempFilePath = '$tempPath/$fileName';

    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(tempFilePath).writeAsBytes(bytes);

    return File(tempFilePath);
  }

  static void showSnackBar(BuildContext context, String error) {
    String errorMessage = error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  // static Future<UserModel> getUserDetails(
  //   String email,
  // ) async {
  //   final userSnapshot = await firestore
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();

  //   // final userData =
  //   //     userSnapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

  //   // return userData;
  // }
}
