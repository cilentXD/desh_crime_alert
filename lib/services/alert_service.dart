import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/models/alert_model.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';

class AlertService {
  static final AlertService _instance = AlertService._internal();
  factory AlertService() => _instance;
  AlertService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _alertsCollection => _db.collection('alerts');
  final _geo = GeoFlutterFire(); // Used for geospatial queries

  Future<void> createAlert({
    required String type,
    required String description,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final geo = GeoFlutterFire();

      final userId = _getCurrentUserId();
      final alertRef = await _db.collection('alerts').add({
        'user_id': userId,
        'type': type,
        'description': description,
        'location': geo
            .point(
              latitude: position.latitude,
              longitude: position.longitude,
            )
            .data,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'status': 'active',
        'additional_data': additionalData,
      });

      // Notify nearby users
      await _notifyNearbyUsers(position, alertRef.id);
    } on PermissionDeniedException catch (e) {
      // from geolocator
      debugPrint('Location service error: ${e.message}');
      throw Exception(
          'Unable to get your location. Please check your location settings.');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error creating alert: ${e.message}');
      throw Exception('Error creating alert: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('Unexpected error creating alert: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('An unexpected error occurred while creating the alert.');
    }
  }

  Stream<List<DocumentSnapshot>> getAlertsStream() {
    return _alertsCollection.snapshots().map((snapshot) => snapshot.docs);
  }

  Stream<List<AlertModel>> getNearbyAlerts(Position center, double radiusKm) {
    final geo = GeoFlutterFire();

    return geo
        .collection(collectionRef: _db.collection('alerts'))
        .within(
          center:
              geo.point(latitude: center.latitude, longitude: center.longitude),
          radius: radiusKm,
          field: 'location',
          strictMode: true,
        )
        .map((List<DocumentSnapshot> docs) {
      return docs.map((doc) => AlertModel.fromFirestore(doc)).toList();
    });
  }

  String _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'anonymous';
  }

  Future<void> _notifyNearbyUsers(Position center, String alertId) async {
    try {
      const radiusInKm = 5.0; // 5km radius
      final geo = GeoFlutterFire();
      final centerPoint = geo.point(
        latitude: center.latitude,
        longitude: center.longitude,
      );

      geo
          .collection(collectionRef: _db.collection('users'))
          .within(
            center: centerPoint,
            radius: radiusInKm,
            field: 'last_location.geopoint',
            strictMode: true,
          )
          .listen((List<DocumentSnapshot> docs) async {
        for (var doc in docs) {
          try {
            // Send notification to nearby user
            final userDoc = await _db.collection('users').doc(doc.id).get();
            if (userDoc.exists && userDoc.data()?['notifications_enabled'] ??
                true) {
              // Store notification in Firestore
              await _db
                  .collection('users')
                  .doc(doc.id)
                  .collection('notifications')
                  .add({
                'alert_id': alertId,
                'type': 'nearby_alert',
                'timestamp': DateTime.now().toUtc().toIso8601String(),
                'read': false,
              });

              // Show local notification
              await NotificationService().showEmergencyNotification(
                title: 'Nearby Alert',
                body: 'A new alert has been reported nearby',
                payload: jsonEncode({
                  'alert_id': alertId,
                  'user_id': doc.id,
                }),
              );
            }
          } catch (e, stackTrace) {
            debugPrint('Error notifying user ${doc.id}: $e');
            debugPrint('Stack trace: $stackTrace');
            // Don't throw here as we want to continue notifying other users
          }
        }
      });
    } on FirebaseException catch (e) {
      debugPrint('Firebase error notifying nearby users: ${e.message}');
      throw Exception('Error notifying nearby users: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('Unexpected error notifying nearby users: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception(
          'An unexpected error occurred while notifying nearby users.');
    }
  }
}
