import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:paw_points/models/location_model.dart';

class ReportModel {
  final String id;
  final String uid;
  final List<String> photos;
  final String subject;
  final String content;
  final LocationModel location;

  ReportModel({
    required this.id,
    required this.uid,
    required this.photos,
    required this.subject,
    required this.content,
    required this.location,
  });

  ReportModel copyWith({
    String? id,
    String? uid,
    List<String>? photos,
    String? subject,
    String? content,
    LocationModel? location,
  }) {
    return ReportModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      photos: photos ?? this.photos,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'photos': photos,
      'subject': subject,
      'content': content,
      'location': location.toMap(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      photos: List<String>.from((map['photos'] as List<String>)),
      subject: map['subject'] as String,
      content: map['content'] as String,
      location: LocationModel.fromMap(map['location'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReportModel(id: $id, uid: $uid, photos: $photos, subject: $subject, content: $content, location: $location)';
  }

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        listEquals(other.photos, photos) &&
        other.subject == subject &&
        other.content == content &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        photos.hashCode ^
        subject.hashCode ^
        content.hashCode ^
        location.hashCode;
  }
}
