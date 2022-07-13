import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String name;
  final String userId;
  final String? withWho;
  final String? photo;
  final LatLng coordinates;
  final DateTime date;
  final String visibility;
  final String? note;

  const Place(
      {required this.id,
      required this.name,
      required this.userId,
      this.withWho,
      this.photo,
      required this.coordinates,
      required this.date,
      required this.visibility,
      this.note});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'],
      name: json['name'],
      userId: json['userId'],
      withWho: json['withWho'],
      photo: json['photo'],
      date: DateTime.parse(json['date']),
      note: json['note'],
      coordinates: LatLng(Coordinates.fromJson(json['coordinates']).latitude,
          Coordinates.fromJson(json['coordinates']).longitude),
      visibility: json['visibility'],
    );
  }
}

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
        latitude: json['latitude'], longitude: json['longitude']);
  }
}
