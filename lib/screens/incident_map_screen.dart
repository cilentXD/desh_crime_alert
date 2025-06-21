import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IncidentMapScreen extends StatefulWidget {
  const IncidentMapScreen({super.key});

  @override
  State<IncidentMapScreen> createState() => _IncidentMapScreenState();
}

class _IncidentMapScreenState extends State<IncidentMapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  String? _mapStyle;
  String? popupTitle;
  String? popupTime;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _setMarkers();
  }

  Future<void> _loadMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    setState(() {
      _mapStyle = style;
    });
  }

  Future<BitmapDescriptor> _customIcon(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      assetPath,
    );
  }

  Future<void> _setMarkers() async {
    final gunIcon = await _customIcon('assets/images/gun.png');
    final fireIcon = await _customIcon('assets/images/fire.png');
    final homeIcon = await _customIcon('assets/images/home.png');
    final liveIcon = await _customIcon('assets/images/fire.png');  // Using fire.png as live icon
    final personIcon = await _customIcon('assets/images/fire.png');  // Using fire.png as person icon

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('gun'),
          position: const LatLng(23.7805733, 90.2792399),
          icon: gunIcon,
          onTap: () {
            _showIncidentPopup("Shots Fired During Carjacking", "10m");
          },
        ),
        Marker(
          markerId: const MarkerId('fire'),
          position: const LatLng(23.7825, 90.2805),
          icon: fireIcon,
          onTap: () {
            _showIncidentPopup("Fire", "LIVE");
          },
        ),
        Marker(
          markerId: const MarkerId('home'),
          position: const LatLng(23.7832, 90.2820),
          icon: homeIcon,
          onTap: () {
            _showIncidentPopup("Mom's house", "");
          },
        ),
        Marker(
          markerId: const MarkerId('live'),
          position: const LatLng(23.7845, 90.2835),
          icon: liveIcon,
          onTap: () {
            _showIncidentPopup("Citizen Network Found Missing Person", "2m");
          },
        ),
        Marker(
          markerId: const MarkerId('person'),
          position: const LatLng(23.7818, 90.2822),
          icon: personIcon,
        ),
      };
    });
  }

  void _showIncidentPopup(String title, String time) {
    setState(() {
      popupTitle = title;
      popupTime = time;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          popupTitle = null;
          popupTime = null;
        });
      }
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
              if (_mapStyle != null) {
                _mapController.setMapStyle(_mapStyle);
              }
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          // Overlay for dark effect
          Container(
            color: Colors.black.withOpacity(0.25),
          ),
          // Top Bar
          const Positioned(
            top: 50,
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
                      "Incidents",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
          // Incident Popup
          if (popupTitle != null)
            Positioned(
              top: 120,
              left: 40,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        popupTitle! + (popupTime!.isNotEmpty ? " · $popupTime" : ""),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // User/Zone Row
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
                  _circleButton(Icons.group, "Family"),
                  const SizedBox(width: 18),
                  _circleButton(Icons.add_alert, "Alert Zones"),
                  const SizedBox(width: 18),
                  _circleAvatar("Ryan"),
                  const SizedBox(width: 18),
                  _circleAvatar("Hawkins"),
                  const SizedBox(width: 18),
                  _circleButton(Icons.home, "Home"),
                ],
              ),
            ),
          ),
          // Alerts section
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
                  Text("Williamsburg",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(height: 6),
                  Text("20 alerts past 24 hr",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF2D2D2D),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _circleAvatar(String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[600],
          child: Text(name[0],
              style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 22)),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }
}
