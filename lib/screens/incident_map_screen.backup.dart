import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

/// A full-screen Google Maps view that shows hard-coded incident markers and
/// bottom navigation identical to the main scaffold. Replace the mock data and
/// navigation callbacks later when wiring up to real logic.
class IncidentMapScreen extends StatefulWidget {
  const IncidentMapScreen({super.key});

  @override
  State<IncidentMapScreen> createState() => _IncidentMapScreenState();
}

// ignore_for_file: deprecated_member_use, unused_field
class _IncidentMapScreenState extends State<IncidentMapScreen> {
  late GoogleMapController _mapController;
  String? _mapStyle;

  // Markers will be added after loading custom icons
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Load map style JSON
    rootBundle.loadString('assets/map_style.json').then((s) => _mapStyle = s);
    _setMarkers();
  }

  /// Load a [BitmapDescriptor] from a local asset image so it can be used as a
  /// custom marker icon on the map.
  Future<BitmapDescriptor> _loadIcon(String assetPath) async {
    // Using fromAssetImage (may show deprecation warning)
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      assetPath,
    );
  }

  /// Create markers with the custom icons and add them to the map.
  Future<void> _setMarkers() async {
    final fireIcon = await _loadIcon('assets/images/fire.png');
    final carIcon = await _loadIcon('assets/images/car.png');
    final homeIcon = await _loadIcon('assets/images/home.png');

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('fire'),
        position: const LatLng(23.7805733, 90.2792399),
        icon: fireIcon,
        infoWindow: const InfoWindow(title: 'Fire Incident'),
      ),
      Marker(
        markerId: const MarkerId('car'),
        position: const LatLng(23.7845, 90.2835),
        icon: carIcon,
        infoWindow: const InfoWindow(title: 'Car Accident'),
      ),
      Marker(
        markerId: const MarkerId('home'),
        position: const LatLng(23.7825, 90.2805),
        icon: homeIcon,
        infoWindow: const InfoWindow(title: 'Home'),
      ),
    };

    setState(() {
      _markers.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.7810, 90.2800),
              zoom: 14,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_mapStyle != null) _mapController.setMapStyle(_mapStyle);
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          // Top bar -----------------------------------------------------------
          const Positioned(
            top: 54,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.layers, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'Incidents',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.search, color: Colors.white, size: 28),
                    SizedBox(width: 15),
                    Icon(Icons.person, color: Colors.white, size: 28),
                  ],
                ),
              ],
            ),
          ),
          // Family / Alert Zones / User bar ----------------------------------
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _circleButton(Icons.group, 'Family'),
                  const SizedBox(width: 18),
                  _circleButton(Icons.add_alert, 'Alert Zones'),
                  const SizedBox(width: 18),
                  _circleAvatar('Ryan'),
                  const SizedBox(width: 18),
                  _circleAvatar('Hawkins'),
                  const SizedBox(width: 18),
                  _circleButton(Icons.home, 'Home'),
                ],
              ),
            ),
          ),
          // Alerts summary card ----------------------------------------------
          Positioned(
            bottom: 110,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF232323),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Williamsburg',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '20 alerts past 24 hr',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar removed as per user request
    );
  }

  // -------------------------------------------------------------------------
  // Helper widgets
  // -------------------------------------------------------------------------
  Widget _circleButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF2D2D2D),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _circleAvatar(String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[600],
          child: Text(
            name[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }
}
