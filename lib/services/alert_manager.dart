import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/models/database_schema.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class AlertManager {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createAlert({
    required String type,
    required String description,
    required Position location,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection(FirestoreSchema.alerts).add({
      'userId': user.uid,
      'type': type,
      'description': description,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _notifyNearbyUsers(location);
  }

  static Stream<QuerySnapshot> getNearbyAlerts(Position location) {
    // Get alerts within 5km radius
    return _db
        .collection(FirestoreSchema.alerts)
        .where('status', isEqualTo: 'active')
        .where('createdAt',
            isGreaterThan: DateTime.now().subtract(const Duration(hours: 1)))
        .snapshots();
  }

  static Future<void> _notifyNearbyUsers(Position location) async {
    // Implementation to notify nearby users
  }
}
