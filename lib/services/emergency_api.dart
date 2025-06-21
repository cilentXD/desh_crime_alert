import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Wrapper for backend integration to send emergency alerts.
class EmergencyApi {
  static const String baseUrl = 'YOUR_API_BASE_URL'; 
  // TODO: replace with env-specific URL.

  static Future<void> sendEmergencyAlert({
    required Position location,
    required String userId,
    required String emergencyType,
  }) async {
    final Uri url = Uri.parse('$baseUrl/emergency-alerts');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'userId': userId,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'emergencyType': emergencyType,
          'timestamp': DateTime.now().toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send alert: ${response.statusCode}');
      }
    } catch (e) {
      // For now just print; in production consider logging to Crashlytics/Sentry
      print('Error sending alert: $e');
      rethrow;
    }
  }
}
