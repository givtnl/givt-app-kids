import 'package:intl/intl.dart';

class Util {
  static String formatDate(DateTime date) {
    DateTime now = DateTime.now();

    // Check if the date is today
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    // Check if the date is yesterday
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    final formatter = DateFormat('MM/dd');

    return formatter.format(date);
  }
}
