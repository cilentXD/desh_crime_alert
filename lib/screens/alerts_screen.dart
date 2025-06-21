
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Incident Feed"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('incidents')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading incidents",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No incidents yet.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final incident = Incident.fromMap(
                docs[index].data() as Map<String, dynamic>,
                docs[index].id,
              );
              return _IncidentCard(incident: incident);
            },
          );
        },
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final Incident incident;
  const _IncidentCard({required this.incident});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F2937),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              incident.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              incident.type,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              incident.description,
              style: const TextStyle(color: Colors.white70),
            ),
            if (incident.imageUrl != null && incident.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  incident.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.place, color: Colors.redAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${incident.location.latitude.toStringAsFixed(2)}, ${incident.location.longitude.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _timeAgo(incident.timestamp),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }
}
