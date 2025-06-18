import 'package:flutter/material.dart';

class CommunityAlertScreen extends StatelessWidget {
  const CommunityAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Alerts'),
        centerTitle: true,
        backgroundColor: Colors.grey[900], // Matching app theme
      ),
      body: const Center(
        child: Text(
          'Community Alerts Feature Screen - Coming Soon!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      backgroundColor: Colors.black, // Matching app theme
    );
  }
}
