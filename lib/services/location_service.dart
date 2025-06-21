import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final _locationStream = StreamController<Position>.broadcast();
  StreamSubscription<Position>? _positionSubscription;

  Stream<Position> get locationStream => _locationStream.stream;

  Future<Position> getCurrentLocation() async {
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

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }

  Future<String> getAddressFromLatLng(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'bn_BD',
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
      }
      return 'Location not found';
    } catch (e) {
      throw Exception('Error getting address: $e');
    }
  }

  Future<void> startTracking() async {
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

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Start location updates
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        _locationStream.add(position);
        _updateUserLocation(position);
      });

    } catch (e) {
      throw Exception('Error starting location tracking: $e');
    }
  }

  Future<void> _updateUserLocation(Position position) async {
    try {
      final geo = GeoFlutterFire();
      final geoPoint = geo.point(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc('cilentXD')
          .update({
        'last_location': {
          'geopoint': geoPoint.data,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        }
      });
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  void dispose() {
    _positionSubscription?.cancel();
    _locationStream.close();
  }
}
