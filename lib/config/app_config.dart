import 'package:intl/intl.dart';

class AppConfig {
  // App Information
  static const String appName = 'Desh Crime Alert';
  static const String appVersion = '1.0.0';
  
  // Current Session
  static const String currentUser = 'cilentXD';
  static final DateTime sessionStart = DateTime.parse('2025-06-19 00:03:16');
  
  // Time Formats
  static final DateFormat timeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  
  // Emergency Numbers
  static const Map<String, String> emergencyContacts = {
    'Police': '999',
    'Ambulance': '999',
    'Fire': '999',
    'Women': '109'
  };
}
