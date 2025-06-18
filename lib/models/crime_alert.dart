import 'package:cloud_firestore/cloud_firestore.dart';

// Models
class CrimeAlert {
  final String id;
  final String type;
  final String location;
  final DateTime time;
  final AlertSeverity severity;
  final String description;

  CrimeAlert({
    required this.id,
    required this.type,
    required this.location,
    required this.time,
    required this.severity,
    required this.description,
  });

  // Factory constructor to create a CrimeAlert from a Firestore document
  factory CrimeAlert.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CrimeAlert(
      id: doc.id,
      type: data['type'] ?? '',
      location: data['location'] ?? '',
      // Firestore stores timestamps, so we need to convert it to DateTime
      time: (data['time'] as Timestamp).toDate(),
      // Convert string from Firestore to AlertSeverity enum
      severity: _severityFromString(data['severity'] ?? 'Low'),
      description: data['description'] ?? '',
    );
  }

  // Helper function to convert string to AlertSeverity
  static AlertSeverity _severityFromString(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AlertSeverity.high;
      case 'medium':
        return AlertSeverity.medium;
      default:
        return AlertSeverity.low;
    }
  }

  // Method to convert a CrimeAlert object to a JSON map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'location': location,
      'time': Timestamp.fromDate(time),
      'severity': severity.toString().split('.').last, // 'AlertSeverity.high' -> 'high'
      'description': description,
    };
  }
}

// alert_severity.dart
enum AlertSeverity { low, medium, high }
