import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/providers/app_state.dart';
import 'package:desh_crime_alert/user_profile_screen.dart';
import 'package:desh_crime_alert/widgets/incident_report_form.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Incident data model
class Incident {
  final String type;
  final IconData icon;
  final Color color;
  final String description;
  final LatLng coordinates;
  final DateTime time;
  final String location;
  final String userId;
  final String? userName;
  final String? imageUrl;

  Incident({
    required this.type,
    required this.icon,
    required this.color,
    required this.description,
    required this.coordinates,
    required this.time,
    required this.location,
    required this.userId,
    this.userName,
    this.imageUrl,
  });
}

// Main screen widget
class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late Stream<List<Incident>> _incidentStream;

  @override
  void initState() {
    super.initState();
    _incidentStream = _getIncidentsStream();
  }

  // Stream to listen for real-time incident reports from Firestore
  Stream<List<Incident>> _getIncidentsStream() {
    return FirebaseFirestore.instance
        .collection('crimeReports')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final incidentType = data['type'] ?? 'Unknown';
        final details = _incidentTypes[incidentType] ??
            {'icon': Icons.help_outline, 'color': Colors.grey};

        return Incident(
          type: incidentType,
          icon: details['icon'],
          color: details['color'],
          description: data['description'] ?? 'No description',
          coordinates: LatLng(
            (data['latitude'] as num?)?.toDouble() ?? 0.0,
            (data['longitude'] as num?)?.toDouble() ?? 0.0,
          ),
          time: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          location: data['location'] ?? 'Unknown location',
          userId: data['userId'] ?? '',
          userName: data['userName'],
          imageUrl: data['imageUrl'],
        );
      }).toList();
    });
  }

  // Incident types and their icon/color
  final Map<String, dynamic> _incidentTypes = {
    'Warning': {'icon': Icons.warning_amber_rounded, 'color': Colors.amber},
    'Robbery': {'icon': Icons.attach_money, 'color': Colors.amber},
    'Fire': {'icon': Icons.local_fire_department, 'color': Colors.redAccent},
    'Police': {'icon': Icons.local_police, 'color': Colors.blueAccent},
    'Assault': {'icon': Icons.personal_injury, 'color': Colors.orange},
    'Theft': {'icon': Icons.wallet, 'color': Colors.yellow},
    'Accident': {'icon': Icons.car_crash, 'color': Colors.blueAccent},
    'Other': {'icon': Icons.help_outline, 'color': Colors.grey},
  };

  double _getMarkerColor(Color color) {
    if (color == Colors.redAccent) return BitmapDescriptor.hueRed;
    if (color == Colors.amber) return BitmapDescriptor.hueYellow;
    if (color == Colors.orange) return BitmapDescriptor.hueOrange;
    if (color == Colors.blueAccent) return BitmapDescriptor.hueAzure;
    return BitmapDescriptor.hueViolet;
  }

  void _showIncidentDetails(BuildContext context, Incident incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1F2937),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(incident.icon, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.type,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${incident.location} • ${DateFormat.jm().format(incident.time)}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                incident.description,
                style: const TextStyle(
                    fontSize: 16, color: Colors.white70, height: 1.5),
              ),
              if (incident.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      incident.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (incident.userId.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(userId: incident.userId),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      incident.userName ?? 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text('Incidents Crime Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _incidentStream = _getIncidentsStream();
                    });
                  },
                ),
              ],
            ),
          ),
          body: StreamBuilder<List<Incident>>(
            stream: _incidentStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No incidents reported yet.', style: TextStyle(color: Colors.white)));
              }

              final incidents = snapshot.data!;
              final markers = incidents.map((incident) {
                return Marker(
                  markerId: MarkerId(incident.description + incident.time.toString()),
                  position: incident.coordinates,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    _getMarkerColor(incident.color),
                  ),
                  infoWindow: InfoWindow(
                    title: incident.type,
                    snippet: incident.location,
                    onTap: () => _showIncidentDetails(context, incident),
                  ),
                );
              }).toSet();

              return GoogleMap(
                initialCameraPosition: appState.currentLocation != null
                    ? CameraPosition(
                        target: LatLng(appState.currentLocation!.latitude,
                            appState.currentLocation!.longitude),
                        zoom: 14)
                    : const CameraPosition(
                        target: LatLng(23.8103, 90.4125), // Default to Dhaka
                        zoom: 12,
                      ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                style: _mapStyle,
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const IncidentReportForm(),
              );
            },
            backgroundColor: const Color(0xFF22D3EE),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

const _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';
