import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart'; // Import Intl package for DateFormat
import 'package:flutter/material.dart'; // Import Material package for Colors

class Incident {
  final String id;
  final String type;
  final String title;
  final String description;
  final String location;
  final String status;
  final GeoPoint coordinates;
  final DateTime timestamp;
  final String userId;
  final String? userName;
  final String? imageUrl;
  final String? videoUrl;
  final bool isAnonymous;
  final int viewers;
  final int notified;
  final String severity;

  Incident({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.coordinates,
    required this.timestamp,
    required this.userId,
    this.userName,
    this.imageUrl,
    this.videoUrl,
    this.isAnonymous = false,
    this.viewers = 0,
    this.notified = 0,
    this.severity = 'medium',
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'location': location,
      'status': status,
      'coordinates': coordinates,
      'timestamp': timestamp,
      'userId': userId,
      'userName': userName,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'isAnonymous': isAnonymous,
      'viewers': viewers,
      'notified': notified,
      'severity': severity,
    };
  }

  // Create from Firestore document
  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      status: map['status'] as String,
      coordinates: GeoPoint(
        (map['coordinates']['latitude'] as num).toDouble(),
        (map['coordinates']['longitude'] as num).toDouble(),
      ),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userId: map['userId'] as String,
      userName: map['userName'] as String?,
      imageUrl: map['imageUrl'] as String?,
      videoUrl: map['videoUrl'] as String?,
      isAnonymous: map['isAnonymous'] as bool,
      viewers: map['viewers'] as int,
      notified: map['notified'] as int,
      severity: map['severity'] as String,
    );
  }

  // Calculate distance from current location
  double calculateDistance(LatLng currentLocation) {
    const double earthRadius = 6371; // Earth radius in kilometers

    double lat1 = coordinates.latitude;
    double lon1 = coordinates.longitude;
    double lat2 = currentLocation.latitude;
    double lon2 = currentLocation.longitude;

    double dLat = (lat2 - lat1) * (math.pi / 180);
    double dLon = (lon2 - lon1) * (math.pi / 180);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) *
            math.cos(lat2 * (math.pi / 180)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }

  // Get formatted time
  String get formattedTime {
    return DateFormat('HH:mm - dd/MM/yyyy').format(timestamp);
  }

  // Get severity color
  Color get severityColor {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
