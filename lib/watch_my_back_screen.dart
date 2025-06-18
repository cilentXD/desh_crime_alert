import 'package:flutter/material.dart';

class WatchMyBackScreen extends StatefulWidget {
  const WatchMyBackScreen({super.key});

  @override
  State<WatchMyBackScreen> createState() => _WatchMyBackScreenState();
}

class _WatchMyBackScreenState extends State<WatchMyBackScreen> {
  bool _isSessionActive = false;

  void _toggleSession() {
    setState(() {
      _isSessionActive = !_isSessionActive;
    });
    // TODO: Add logic to handle session start/stop (e.g., location tracking, notifications)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text('Session', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Watch My Back session ${_isSessionActive ? "started" : "stopped"}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch My Back'),
        centerTitle: true,
        backgroundColor: Colors.grey[900], // Matching app theme
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isSessionActive ? 'Session Active' : 'Session Inactive',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isSessionActive ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSessionActive ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: _toggleSession,
              child: Text(_isSessionActive ? 'Stop Session' : 'Start Session'),
            ),
            const SizedBox(height: 40),
            // Placeholder for future features
            const Text(
              'Future features like trusted contacts and timer will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Matching app theme
    );
  }
}
