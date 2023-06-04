class UserModel {
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoURL;
  final String? uid;
  final String? registeredType;

  UserModel({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.uid,
    required this.registeredType,
  });

  UserModel copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    String? uid,
    String? registeredType,
  }) {
    return UserModel(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      uid: uid ?? this.uid,
      registeredType: registeredType ?? this.registeredType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'uid': uid,
      'registeredType': registeredType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName: map['displayName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      uid: map['uid'],
      registeredType: map['registeredType'],
    );
  }

  @override
  String toString() {
    return 'UserModel(displayName: $displayName, email: $email, phoneNumber: $phoneNumber, photoURL: $photoURL, uid: $uid, registeredType: $registeredType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.displayName == displayName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.photoURL == photoURL &&
        other.uid == uid &&
        other.registeredType == registeredType;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        photoURL.hashCode ^
        uid.hashCode ^
        registeredType.hashCode;
  }
}
