import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoFactorAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Security Settings'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Change Password', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Update your account password', style: TextStyle(color: Colors.white70)),
            leading: const Icon(Icons.lock_outline, color: Colors.white70),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change Password feature coming soon!'),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            },
          ),
          const Divider(color: Colors.grey),
          SwitchListTile.adaptive(
            title: const Text('Two-Factor Authentication', style: TextStyle(color: Colors.white, fontSize: 16)),
            subtitle: const Text('Add an extra layer of security to your account', style: TextStyle(color: Colors.white70)),
            value: _twoFactorAuth,
            onChanged: (value) {
              setState(() {
                _twoFactorAuth = value;
              });
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Two-Factor Authentication is now ${_twoFactorAuth ? "enabled" : "disabled"}.'),
                  backgroundColor: _twoFactorAuth ? Colors.green : Colors.red,
                ),
              );
            },
            secondary: const Icon(Icons.shield_outlined, color: Colors.white70),
            activeColor: Colors.blueAccent,
            inactiveTrackColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }
}
