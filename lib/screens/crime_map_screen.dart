import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CrimeMapScreen extends StatefulWidget {
  const CrimeMapScreen({super.key});

  @override
  State<CrimeMapScreen> createState() => _CrimeMapScreenState();
}

class _CrimeMapScreenState extends State<CrimeMapScreen> {
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthAndFetch();
  }

  void _checkAuthAndFetch() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _fetchCrimeReports();
    } else {
      debugPrint("User not logged in. Cannot fetch reports.");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Please log in to view the crime map.";
        });
      }
    }
  }

  Future<void> _fetchCrimeReports() async {
    debugPrint("Fetching crime reports from Firestore...");
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('reports').get();
      final reports = snapshot.docs;
      debugPrint("Found ${reports.length} reports.");

      if (reports.isEmpty) {
        debugPrint("The 'reports' collection is empty. No markers to show.");
      }

      for (var report in reports) {
        final data = report.data();
        debugPrint("Processing report ${report.id}: $data");

        final dynamic locationData = data['location'];
        GeoPoint? location;

        if (locationData is GeoPoint) {
          location = locationData;
        }

        final String crimeType = data['crimeType'] ?? 'Unknown';
        final String reportId = report.id;

        if (location != null) {
          debugPrint(
              "Location found: Lat ${location.latitude}, Lng ${location.longitude}");
          _markers.add(
            Marker(
              markerId: MarkerId(reportId),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: crimeType,
                snippet: 'Tap for details',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                _getMarkerHue(crimeType),
              ),
            ),
          );
        } else {
          debugPrint(
              "Report ${report.id} does not have a valid 'location' (GeoPoint) field.");
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching reports: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorMessage = "Could not load crime data.";
    }

    debugPrint(
        "Finished fetching. Updating state with ${_markers.length} markers.");
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _getMarkerHue(String crimeType) {
    switch (crimeType.toLowerCase()) {
      case 'theft':
        return BitmapDescriptor.hueOrange;
      case 'robbery':
        return BitmapDescriptor.hueRed;
      case 'harassment':
        return BitmapDescriptor.hueViolet;
      default:
        return BitmapDescriptor.hueAzure;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if (_isLoading) {
      bodyWidget = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      bodyWidget = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    } else {
      bodyWidget = GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.8103, 90.4125), // Centered on Dhaka
          zoom: 12,
        ),
        markers: _markers,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Map'),
        backgroundColor: Colors.blue[700],
      ),
      body: bodyWidget,
    );
  }
}
