import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(String message) {
    if (kDebugMode) {
      // Only print in debug mode
      print('DEBUG: $message');
    }
    // In production, you can integrate with crashlytics or other logging services here
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) print('Error details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
    // In production, log to crash reporting service
  }

  static void info(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }
}
