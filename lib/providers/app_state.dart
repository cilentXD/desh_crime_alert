import 'dart:async';

import 'package:desh_crime_alert/models/alert_model.dart';
import 'package:desh_crime_alert/models/user_model.dart';
import 'package:desh_crime_alert/services/alert_service.dart';
import 'package:desh_crime_alert/services/auth_service.dart';
import 'package:desh_crime_alert/services/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class AppState extends ChangeNotifier {
  // Private state variables
  UserModel? _currentUser;
  Position? _currentLocation;
  String? _currentAddress;
  List<AlertModel> _nearbyAlerts = [];
  bool _isLoading = true; // Start with loading true

  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<List<AlertModel>>? _alertsSubscription;
  final LocationService _locationService = LocationService();
  final AlertService _alertService = AlertService();

  // Getters to access state
  UserModel? get currentUser => _currentUser;
  Position? get currentLocation => _currentLocation;
  String? get currentAddress => _currentAddress;
  List<AlertModel> get nearbyAlerts => _nearbyAlerts;
  bool get isLoading => _isLoading;

  AppState() {
    initialize();
  }

  Future<void> initialize() async {
    try {
      // Fetch initial user data
      _currentUser = await AuthService().getCurrentUser();
      notifyListeners();

      // Start location tracking
      await _locationService.startTracking();

      // Fetch initial location data and start listening for updates
      _currentLocation = await LocationService().getCurrentLocation();
      if (_currentLocation != null) {
        _currentAddress =
            await LocationService().getAddressFromLatLng(_currentLocation!);
        _listenToLocationChanges();
        _listenToNearbyAlerts(_currentLocation!);
      }
    } catch (e) {
      // In a real app, you might want to log this to a service
      debugPrint('Error initializing AppState: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  void _listenToLocationChanges() {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.locationStream.listen((position) async {
      _currentLocation = position;
      _currentAddress = await _locationService.getAddressFromLatLng(position);

      // When location changes, we need to re-subscribe to nearby alerts
      _listenToNearbyAlerts(position);

      notifyListeners();
    });
  }

  void _listenToNearbyAlerts(Position position) {
    _alertsSubscription?.cancel();
    _alertsSubscription = _alertService.getNearbyAlerts(position, 5.0).listen((alerts) {
      _nearbyAlerts = alerts;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _alertsSubscription?.cancel();
    super.dispose();
  }
}
