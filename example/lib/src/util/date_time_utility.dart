import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatToString(String format) {
    return DateFormat(format).format(this);
  }

  bool isSameDate(DateTime? dateTime) {
    return year == dateTime?.year &&
        month == dateTime?.month &&
        day == dateTime?.day;
  }

  bool isSameDateString(String? dateTimeString) {
    final dateTime = dateTimeString?.formatToDateTime(format2);
    return year == dateTime?.year &&
        month == dateTime?.month &&
        day == dateTime?.day;
  }

  int daysBetween(DateTime to) {
    final fromDae = DateTime(year, month, day);
    final toDate = DateTime(to.year, to.month, to.day);
    return (toDate.difference(fromDae).inHours / 24).round();
  }

  bool isAfterOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isAfter(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isBefore(other);
  }

  bool isBetween({required DateTime from, required DateTime to}) {
    return isAfterOrEqual(from) && isBeforeOrEqual(to);
  }

  bool isToday() {
    return isSameDate(DateTime.now());
  }

  ({DateTime startDate, DateTime endDate}) weekStartEndDates(
      {int weekDay = DateTime.sunday}) {
    // Find the Sunday of the current week (start date)
    /*DateTime startDate = subtract(Duration(days: weekDay));
    if(weekday == DateTime.sunday) {
      startDate = this;
    }*/

    DateTime startDate = DateTime(year, month, day - (weekday - weekDay) % 7);

    // Find the Saturday of the current week (end date)
    DateTime endDate = startDate.add(const Duration(days: 6));
    return (startDate: startDate, endDate: endDate);
  }

  ({DateTime startDate, DateTime endDate}) monthStartEndDates() {
    // Use DateTime.now() or provided date as reference
    // Get the first day of the month
    final startDate = DateTime(year, month, 1);

    // Get the last day of the month (handles leap year)
    final endDate = DateTime(
      year,
      month + 1,
    ).subtract(const Duration(days: 1));

    return (startDate: startDate, endDate: endDate);
  }

  List<DateTime> getDatesBetween({required DateTime endDate}) {
    final difference = endDate.difference(this).inDays;
    return [
      for (int i = 0; i <= difference; i++) add(Duration(days: i)),
    ];
  }

  String rangeString({
    required bool isMonthRange,
    required DateTime endDateTime,
  }) {
    final now = DateTime.now();
    final isBetweenDifference = now.isBetween(from: this, to: endDateTime);

    return isMonthRange
        ? isBetweenDifference
            ? 'This Month'
            : formatToString(format17)
        : isBetweenDifference
            ? 'This Week'
            : '${formatToString(format14)} - ${endDateTime.formatToString(format14)}';
  }
}

extension StringDateTimeExtension on String {
  DateTime? formatToDateTime(String format) =>
      (isEmpty) ? null : DateTime.parse(this);

  String formatToString(String format) =>
      (isEmpty) ? '' : DateFormat(format).format(DateTime.parse(this));

  bool isToday() {
    if (isEmpty) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final dateTime = DateTime.parse(this);
    return today == DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Project related methods
}

extension TimeAgoDateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

/// Sat, 20 Aug 2022, 11:16 AM
String format1 = 'EEE, d MMM yyyy hh:mm a';

/// 2022-01-01
String format2 = 'yyyy-MM-dd';

/// 11:16 AM (12 hours format)
String format3 = 'hh:mm a';

// 14:10:02 (24 hours format)
String format4 = 'HH:mm:ss';

/// Wed, August 24, 2022
String format5 = 'EEE, MMMM d, yyyy';

/// 20 Aug 2022, 11:16 AM
String format6 = 'd MMM yyyy';

String format7 = 'd MMM yyyy hh:mm a';

/// Thursday Aug 10 2023
String format8 = 'EEEE MMM d yyyy';

/// 20220828
String format9 = 'yyyyMMdd';

/// Wed
String format10 = 'EEE';

/// Tuesday, February 14, 2024
String format12 = 'EEEE, MMMM d yyyy';

/// February 14, 2024
String format13 = 'MMMM d, yyyy';

// 2/10/24
String format14 = 'M/d/yy';

//  Wed, August 24,
String format15 = 'EEE, MMM d';

// Mar 29
String format16 = 'MMM d';

String format17 = 'MMMM - yyyy';
