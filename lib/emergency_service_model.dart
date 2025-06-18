import 'package:flutter/material.dart'; // For Color type

class EmergencyService {
  final String name;
  final String
  icon; // React code used emoji, Flutter can use IconData or image path
  final String number;
  final Color color; // React code used Tailwind CSS color class string

  EmergencyService({
    required this.name,
    required this.icon, // For now, let's keep it as a string, can be an IconData later
    required this.number,
    required this.color,
  });
}
