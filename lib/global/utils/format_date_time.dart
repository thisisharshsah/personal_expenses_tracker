import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(DateTime date) {
  String formattedDate = '';
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  formattedDate =
  '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}, ${date.year}';
  return formattedDate;
}

String convertTimestamp(Timestamp timestamp) {
  final date = timestamp.toDate();
  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final day = date.day;
  final month = months[date.month - 1];
  final year = date.year;
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  final second = date.second.toString().padLeft(2, '0');
  return '$day $month, $year at $hour:$minute:$second';
}