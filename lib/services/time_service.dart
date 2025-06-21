import 'package:intl/intl.dart';

class TimeService {
  static DateTime get currentUtcTime => DateTime.now().toUtc();

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
