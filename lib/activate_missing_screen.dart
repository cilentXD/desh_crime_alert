import 'package:flutter/material.dart';

class ActivateMissingScreen extends StatelessWidget {
  const ActivateMissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activate Missing Person'),
        centerTitle: true,
        backgroundColor: Colors.grey[900], // Matching app theme
      ),
      body: const Center(
        child: Text(
          'Activate Missing Person Feature Screen - Coming Soon!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      backgroundColor: Colors.black, // Matching app theme
    );
  }
}
