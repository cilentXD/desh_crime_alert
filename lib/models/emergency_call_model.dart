import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyModel {
  final String callId;
  final String userId;
  final String serviceType; // e.g., 'police', 'ambulance', 'fire'
  final Map<String, dynamic> location;
  final DateTime timestamp;
  final String status; // e.g., 'dialed', 'responded', 'resolved'
  final String? response; // Optional: details of the response

  EmergencyModel({
    required this.callId,
    required this.userId,
    required this.serviceType,
    required this.location,
    required this.timestamp,
    required this.status,
    this.response,
  });

  // From Firestore
  factory EmergencyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmergencyModel(
      callId: doc.id,
      userId: data['user_id'] ?? '',
      serviceType: data['service_type'] ?? '',
      location: data['location'] ?? {},
      timestamp: DateTime.parse(data['timestamp'] ?? '2025-06-19 21:08:53'),
      status: data['status'] ?? 'dialed',
      response: data['response'],
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'service_type': serviceType,
      'location': location,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'status': status,
      'response': response,
    };
  }
}
