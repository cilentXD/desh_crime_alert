import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/emergency_api.dart';

class EmergencyState extends ChangeNotifier {
  static final EmergencyState _instance = EmergencyState._internal();
  
  EmergencyState._internal() {
    _init();
  }

  factory EmergencyState() => _instance;

  Position? _currentLocation;
  String _address = '';
  bool _isLoading = false;

  Position? get currentLocation => _currentLocation;
  String get address => _address;
  bool get isLoading => _isLoading;

  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();
  final EmergencyApi _emergencyApi = EmergencyApi(); // Used for sending emergency alerts

  void _init() async {
    _locationService.startTracking();
    _locationService.locationStream.listen((position) {
      _currentLocation = position;
      updateAddress();
    });
  }

  Future<void> updateAddress() async {
    try {
      if (_currentLocation != null) {
        final placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          localeIdentifier: 'bn_BD', // Using Bengali locale for Bangladesh
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          _address = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
        } else {
          _address = 'Location not available';
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      _address = 'Location not available';
      notifyListeners();
    }
  }

  Future<void> updateLocation() async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentLocation = await _locationService.getCurrentLocation();
      await updateAddress();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating location: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends SOS alert to backend and shows local notification
  Future<void> triggerEmergency(String userId, String type) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_currentLocation == null) {
        await updateLocation();
      }

      if (_currentLocation == null) {
        throw Exception('Failed to get current location');
      }

      await EmergencyApi.sendEmergencyAlert(
        userId: userId,
        location: _currentLocation!,
        emergencyType: type,
      );

      await _notificationService.showEmergencyNotification(
        title: 'Emergency Alert',
        body: 'SOS alert sent successfully',
      );
      
    } catch (e) {
      await _notificationService.showEmergencyNotification(
        title: 'Error',
        body: 'Failed to send emergency alert: ${e.toString()}',
      );
      debugPrint('Error triggering emergency: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
