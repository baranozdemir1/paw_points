import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paw_points/models/report_model.dart';
import 'package:uuid/uuid.dart';

import '../../models/location_model.dart';
import '../providers/firebase_provider.dart';

final reportRepositoryProvider = Provider<ReportRepository>(
  (ProviderRef<ReportRepository> ref) => ReportRepository(
    firestore: ref.read(firestoreProvider),
    storage: ref.read(storageProvider),
  ),
);

class ReportRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ReportRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _reports => _firestore.collection('reports');

  Reference get _storageRef => _storage.ref();

  Future<ReportModel?> addReport(
    String uid,
    List<String> photos,
    String subject,
    String content,
    LocationModel location,
    BuildContext context,
  ) async {
    try {
      String reportId = const Uuid().v4();

      if (photos.isEmpty) {
        ReportModel reportModel = ReportModel(
          id: reportId,
          uid: uid,
          photos: [],
          subject: subject,
          content: content,
          location: location,
        );

        await _reports.doc(reportId).set(reportModel.toMap());
        await _users.doc(uid).update({
          'reports': FieldValue.arrayUnion([reportId]),
        });

        return reportModel;
      }
      List<File> imageFiles = photos.map((photo) => File(photo)).toList();
      List<String> photoLinks = await uploadFiles(imageFiles, reportId);

      ReportModel reportModel = ReportModel(
        id: reportId,
        uid: uid,
        photos: photoLinks,
        subject: subject,
        content: content,
        location: location,
      );

      await _reports.doc(reportId).set(reportModel.toMap());
      await _users.doc(uid).update({
        'reports': FieldValue.arrayUnion([reportId]),
      });

      return reportModel;
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

  Future<List<String>> uploadFiles(
    List<File> images,
    String reportId,
  ) async {
    // images map and get each index
    List<String> imageUrls = await Future.wait(
      images.map(
        (image) => uploadFile(
          image,
          reportId,
          images.indexOf(image).toDouble(),
        ),
      ),
    );
    print('imageUrls $imageUrls');

    return imageUrls;
  }

  Future<String> uploadFile(
    File image,
    String reportId,
    double index,
  ) async {
    Reference storageRef = _storageRef
        .child(
          'reportImages',
        )
        .child(
          '$reportId-$index',
        );
    await storageRef.putFile(image);

    return storageRef.getDownloadURL();
  }
}
