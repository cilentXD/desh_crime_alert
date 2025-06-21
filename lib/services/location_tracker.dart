import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/constants/model_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class LocationTracker {
  static const Duration updateInterval = Duration(minutes: 1);

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  static Future<void> updateUserLocation(Position position) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection(ModelConstants.usersCollection)
        .doc(user.uid)
        .update({
      'last_location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': position.timestamp.toUtc().toIso8601String(),
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'altitudeAccuracy': position.altitudeAccuracy,
        'heading': position.heading,
        'headingAccuracy': position.headingAccuracy,
        'speed': position.speed,
        'speedAccuracy': position.speedAccuracy,
      },
      'last_active': DateTime.now().toUtc().toIso8601String(),
      'is_online': true,
    });
  }
}
