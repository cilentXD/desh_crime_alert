import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _shareLocation = true;
  bool _publicProfile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSwitchTile(
            title: 'Live Location Sharing',
            subtitle: 'Allow trusted contacts to see your live location',
            value: _shareLocation,
            onChanged: (value) {
              setState(() {
                _shareLocation = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Public Profile',
            subtitle: 'Make your profile visible to other users',
            value: _publicProfile,
            onChanged: (value) {
              setState(() {
                _publicProfile = value;
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
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blueAccent,
      inactiveTrackColor: Colors.grey[800],
    );
  }
}
