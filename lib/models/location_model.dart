import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;
  final double? speed;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.speed,
  });

  // From Firestore
  factory LocationModel.fromFirestore(Map<String, dynamic> data) {
    return LocationModel(
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      accuracy: data['accuracy'],
      speed: data['speed'],
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'accuracy': accuracy,
      'speed': speed,
    };
  }
}
