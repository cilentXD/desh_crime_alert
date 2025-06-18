import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/user_profile_screen.dart';
import 'package:desh_crime_alert/widgets/incident_report_form.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late Stream<List<Incident>> _incidentStream = _getIncidentsStream();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent, // Set Scaffold background to transparent
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(40.0), // Set preferred AppBar height to 40.0
        child: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 15.0), // Adjust this value to move the title down
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
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No incidents reported yet.'));
          }

          final incidents = snapshot.data!;
          final Set<Marker> markers = incidents.map((incident) {
            return Marker(
              markerId: MarkerId(incident.type + incident.time.toIso8601String()),
              position: incident.coordinates,
              infoWindow: InfoWindow(
                title: incident.type,
                snippet: incident.location,
                onTap: () => _showIncidentDetails(context, incident),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                incident.color == Colors.redAccent
                    ? BitmapDescriptor.hueRed
                    : incident.color == Colors.amber
                        ? BitmapDescriptor.hueYellow
                        : incident.color == Colors.blue
                            ? BitmapDescriptor.hueBlue
                            : BitmapDescriptor.hueGreen,
              ),
            );
          }).toSet();

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.777176, 90.399452), // Dhaka, Bangladesh coordinates
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const IncidentReportForm(),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }

  void _showIncidentDetails(BuildContext context, Incident incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
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
}
