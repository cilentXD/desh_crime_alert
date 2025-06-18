import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _nearbyIncidents = true;
  bool _communityAlerts = true;
  bool _sosAlerts = true;
  bool _appUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSwitchTile(
            title: 'Nearby Incidents',
            subtitle: 'Get notified about incidents happening near you',
            value: _nearbyIncidents,
            onChanged: (value) {
              setState(() {
                _nearbyIncidents = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Community Alerts',
            subtitle: 'Receive alerts from your community members',
            value: _communityAlerts,
            onChanged: (value) {
              setState(() {
                _communityAlerts = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'SOS Alerts',
            subtitle: 'Critical alerts when someone sends an SOS',
            value: _sosAlerts,
            onChanged: (value) {
              setState(() {
                _sosAlerts = value;
              });
            },
          ),
          Divider(color: Colors.grey[700]),
          _buildSwitchTile(
            title: 'App Updates',
            subtitle: 'Get notified about new features and updates',
            value: _appUpdates,
            onChanged: (value) {
              setState(() {
                _appUpdates = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blueAccent,
      inactiveTrackColor: Colors.grey[800],
    );
  }
}
