import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime format(String format) {
    final formattedString = formatToString(format);
    return DateFormat(format).parse(formattedString);
  }

  String formatToString(String format) {
    return DateFormat(format).format(this);
  }
}

/// Provides standard date format components.
abstract class DateFormatComponents {
  /// Year components
  ///
  /// Formats year as: 2025
  static const year4Digit = 'yyyy';

  /// Formats year as: 25
  static const year2Digit = 'yy';

  /// Month components
  ///
  ///
  static const month2Digit = 'MM'; // 01
  static const monthShortName = 'MMM'; // Jan, Feb, etc.
  static const monthFullName = 'MMMM'; // January, February, etc.

  // Day components
  static const day2Digit = 'dd'; // 08
  static const dayOfMonth = 'd'; // 8 without leading zero

  // Weekday components
  static const weekdayShortName = 'EEE'; // Mon, Tue, etc.
  static const weekdayFullName = 'EEEE'; // Monday, Tuesday, etc.

  // Hour components
  static const hour24 = 'HH'; // 17
  static const hour12LeadingZero = 'hh'; // 05
  static const hour12 = 'h'; // 5

  // Minute components
  static const minute2Digit = 'mm'; // 05

  // Second components
  static const second2Digit = 'ss'; // 00

  // AM/PM marker
  static const amPm = 'A'; // AM | PM
}

abstract class DateFormatStrings {
  /// Formats as: 01/06/25
  static const String monthDayYear =
      '${DateFormatComponents.month2Digit}/${DateFormatComponents.day2Digit}/${DateFormatComponents.year2Digit}';
}

abstract class TimeFormatString {
  /// Formats as: 1:00 PM
  static const String hourMinute12Hour =
      '${DateFormatComponents.hour12}:${DateFormatComponents.minute2Digit} ${DateFormatComponents.amPm}';
}

abstract class DateTimeFormatStrings {
  // Formats as: 01/06/25, 1:00 PM
  static const String monthDayYearHourMinute12Hour =
      '${DateFormatStrings.monthDayYear}, ${TimeFormatString.hourMinute12Hour}';
}
