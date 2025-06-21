import 'dart:async';

import 'package:desh_crime_alert/services/location_tracker.dart';
import 'package:desh_crime_alert/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  bool _isSyncStarted = false;

  Position? get currentPosition => _currentPosition;

  void startTracking() {
    _positionStream = LocationTracker.getPositionStream().listen(
      (Position position) {
        _currentPosition = position;
        LocationTracker.updateUserLocation(position);

        if (!_isSyncStarted) {
          SyncService.instance.startSync(currentPosition: position);
          _isSyncStarted = true;
        }

        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    SyncService.instance.dispose();
    super.dispose();
  }
}
