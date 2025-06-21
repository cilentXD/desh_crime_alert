import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/models/emergency_call_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyService {
  static final EmergencyService _instance = EmergencyService._internal();
  factory EmergencyService() => _instance;
  EmergencyService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> makeEmergencyCall(String type) async {
    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition();
      
      // Log emergency call
      final callRef = await _db.collection('emergency_calls').add({
        'user_id': 'cilentXD',
        'type': type,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
        'status': 'pending',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      // Send SMS to nearby police stations
      await _sendSmsToNearbyStations(position, callRef.id, type);

      // Launch phone call
      final Uri callUri = Uri(
        scheme: 'tel',
        path: _getEmergencyNumber(type),
      );
      
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        throw Exception('Could not launch URL');
      }

      // Update call status
      await _db.collection('emergency_calls').doc(callRef.id).update({
        'status': 'initiated',
        'call_started_at': DateTime.now().toUtc().toIso8601String(),
      });

    } catch (e) {
      throw Exception('Error making emergency call: $e');
    }
  }

  Future<List<EmergencyModel>> getRecentCalls() async {
    try {
      final snapshots = await _db
          .collection('emergency_calls')
          .where('user_id', isEqualTo: 'cilentXD')
          .orderBy('created_at', descending: true)
          .limit(20)
          .get();

      return snapshots.docs
          .map((doc) => EmergencyModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching recent calls: $e');
    }
  }

  String _getEmergencyNumber(String type) {
    switch (type.toLowerCase()) {
      case 'police':
        return '999';
      case 'ambulance':
        return '102';
      case 'fire':
        return '199';
      default:
        return '109';
    }
  }

  Future<void> _sendSmsToNearbyStations(Position position, String callId, String type) async {
    try {
      // Get nearby police stations (implement this with GeoFlutterFire)
      // For now, just log the attempt
      print('Sending SMS to nearby stations for call $callId');
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }
}
