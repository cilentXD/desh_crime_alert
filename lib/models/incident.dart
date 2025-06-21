import 'package:cloud_firestore/cloud_firestore.dart';

class Incident {
  final String id;
  final String type;
  final String title;
  final String description;
  final String? imageUrl;
  final GeoPoint location;
  final DateTime timestamp;


  Incident({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.location,
    required this.timestamp,

  });

  factory Incident.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Incident.fromMap(data, doc.id);
  }

  /// Create Incident from Map data & provided document id
  factory Incident.fromMap(Map<String, dynamic> map, String docId) {
    return Incident(
      id: docId,
      type: map['type'] ?? 'Unknown',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      location: map['location'] ?? const GeoPoint(0, 0),
      timestamp: (map['timestamp'] as Timestamp).toDate(),

    );
  }

  Map<String, dynamic> toFirestore() => {
        'type': type,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'location': location,
        'timestamp': Timestamp.fromDate(timestamp),
        
      };
}
