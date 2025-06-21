import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Session Data
  static Future<void> saveUserSession(String userId) async {
    final prefs = await _prefs;
    await prefs.setString('user_id', userId);
    await prefs.setString('last_login', DateTime.now().toIso8601String());
  }

  // Activity Logging
  static Future<void> logUserActivity(String activity) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('Cannot log activity: User not signed in.');
        return;
      }
      await _db.collection('user_activities').add({
        'user_id': userId,
        'activity': activity,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'device_info': await _getDeviceInfo()
      });
    } catch (e) {
      print('Error logging activity: $e');
    }
  }

  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'android',
        'model': androidInfo.model,
        'version': androidInfo.version.release,
      };
    }
    // Add iOS support if needed
    return {'platform': 'unknown'};
  }
}
