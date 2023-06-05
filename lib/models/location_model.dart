import 'dart:convert';

class LocationModel {
  final String id;
  final double latitude;
  final double longitude;
  final String name;

  LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  LocationModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return LocationModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocationModel(id: $id, latitude: $latitude, longitude: $longitude, name: $name)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ latitude.hashCode ^ longitude.hashCode ^ name.hashCode;
  }
}
