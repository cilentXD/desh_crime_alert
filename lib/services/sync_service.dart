import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class SyncService {
  static final instance = SyncService._();
  SyncService._();

  final _db = FirebaseFirestore.instance;
  final _syncController = StreamController<void>.broadcast();
  Timer? _syncTimer;

  void startSync({required Position currentPosition}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _syncData(currentPosition: currentPosition);
    });
  }

  Future<void> _syncData({required Position currentPosition}) async {
    try {
      // FIXME: Hardcoded user ID. Should use the currently logged-in user.
      await _db.collection('users').doc('cilentXD').update({
        'last_active': DateTime.now().toUtc().toIso8601String(),
        'last_location': {
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        }
      });

      _syncController.add(null);
    } catch (e) {
      print('Sync error: $e');
    }
  }

  void dispose() {
    _syncTimer?.cancel();
    _syncController.close();
  }
}
