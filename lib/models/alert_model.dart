import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  final String alertId;
  final String userId;
  final String type;
  final String description;
  final Map<String, dynamic> location;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  AlertModel({
    required this.alertId,
    required this.userId,
    required this.type,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });

  // From Firestore
  factory AlertModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlertModel(
      alertId: doc.id,
      userId: data['user_id'] ?? 'cilentXD',
      type: data['type'] ?? 'Emergency',
      description: data['description'] ?? '',
      location: data['location'] ?? {},
      status: data['status'] ?? 'active',
      createdAt: DateTime.parse(data['created_at'] ?? '2025-06-19 21:08:53'),
      resolvedAt: data['resolved_at'] != null 
          ? DateTime.parse(data['resolved_at'])
          : null,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'type': type,
      'description': description,
      'location': location,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'resolved_at': resolvedAt?.toUtc().toIso8601String(),
    };
  }
}
