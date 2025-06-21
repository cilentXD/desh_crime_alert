import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String phone;
  final String? name;
  final DateTime lastActive;
  final Map<String, dynamic> lastLocation;
  final bool isOnline;

  UserModel({
    required this.userId,
    required this.phone,
    this.name,
    required this.lastActive,
    required this.lastLocation,
    this.isOnline = false,
  });

  // From Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      phone: data['phone'] ?? '',
      name: data['name'],
      lastActive: DateTime.parse(data['last_active'] ?? '2025-06-19 21:08:53'),
      lastLocation: data['last_location'] ?? {},
      isOnline: data['is_online'] ?? false,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'phone': phone,
      'name': name,
      'last_active': lastActive.toUtc().toIso8601String(),
      'last_location': lastLocation,
      'is_online': isOnline,
    };
  }
}
