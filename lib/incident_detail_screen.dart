import 'package:flutter/material.dart';
import 'incident_model.dart';
import 'utils/logger.dart'; // Corrected import path

class IncidentDetailScreen extends StatelessWidget {
  final Incident incident;

  const IncidentDetailScreen({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(incident.title),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            if (incident.imageUrl != null && incident.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    incident.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      AppLogger.error(
                          'Error loading incident image: ${incident.imageUrl}, Error: $error');
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_outlined,
                                  color: Colors.white54, size: 48),
                              SizedBox(height: 8),
                              Text('Could not load image',
                                  style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            _buildDetailItem(
                icon: Icons.category_outlined,
                label: 'Type',
                value: incident.type
                    .toString()
                    .split('.')
                    .last), // Convert enum to string
            const SizedBox(height: 12),
            _buildDetailItem(
                icon: Icons.description_outlined,
                label: 'Description',
                value: incident.description,
                isMultiline: true),
            const SizedBox(height: 12),
            _buildDetailItem(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: incident.location),
            const SizedBox(height: 12),
            _buildDetailItem(
                icon: Icons.access_time_outlined,
                label: 'Time',
                value: incident.formattedTime),
            const SizedBox(height: 12),
            _buildDetailItem(
                icon: Icons.info_outline,
                label: 'Status',
                value: incident.status),
            const SizedBox(height: 12),
            // Placeholder for Map View
            Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey[700]!)),
              child: const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 48, color: Colors.white54),
                  SizedBox(height: 8),
                  Text('Map View Placeholder',
                      style: TextStyle(color: Colors.white54)),
                ],
              )),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            _buildActionButtons(context),
            const SizedBox(height: 20),
            // Viewer/Notified Counts
            _buildCounts(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      {required IconData icon,
      required String label,
      required String value,
      bool isMultiline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: isMultiline ? 1.4 : 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _actionButton(context,
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () => AppLogger.info('Share tapped')),
        _actionButton(context,
            icon: Icons.notifications_active_outlined,
            label: 'Notify',
            onTap: () => AppLogger.info('Notify tapped')),
        _actionButton(context,
            icon: Icons.message_outlined,
            label: 'Message',
            onTap: () => AppLogger.info('Message tapped')),
      ],
    );
  }

  Widget _actionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18, color: Colors.white70),
      label: Text(label, style: const TextStyle(color: Colors.white70)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildCounts() {
    // Use direct values as they are non-nullable in the model
    final int viewers = incident.viewers;
    final int notified = incident.notified;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _countItem(
            icon: Icons.visibility_outlined, count: viewers, label: 'Viewers'),
        _countItem(
            icon: Icons.notifications_on_outlined,
            count: notified,
            label: 'Notified'),
      ],
    );
  }

  Widget _countItem(
      {required IconData icon, required int count, required String label}) {
    return Column(
      children: <Widget>[
        Icon(icon, color: Colors.tealAccent, size: 24),
        const SizedBox(height: 4),
        Text('$count',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}
