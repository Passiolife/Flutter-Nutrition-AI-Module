import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime format(String format) {
    final formattedString = formatToStringNew(format);
    return DateFormat(format).parse(formattedString);
  }

  String formatToStringNew(String format) {
    return DateFormat(format).format(this);
  }

  bool isSameDate(DateTime? dateTime) {
    return year == dateTime?.year &&
        month == dateTime?.month &&
        day == dateTime?.day;
  }

  bool get isToday => isSameDate(DateTime.now());
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
  static const amPm = 'a'; // AM | PM
}

abstract class DateFormatStrings {
  // Date Format: MM/dd/yy
  /// Formats as: 01/06/25
  static const String monthDayYear =
      '${DateFormatComponents.month2Digit}/${DateFormatComponents.day2Digit}/${DateFormatComponents.year2Digit}';

  // Date Format: yyyyMMdd
  /// Formats as: 20250226
  static const String yearMonthDay =
      '${DateFormatComponents.year4Digit}${DateFormatComponents.month2Digit}${DateFormatComponents.day2Digit}';

  // Date Format: yyyy/MM/dd
  /// Formats as: 2025/02/26
  static const String slashYmd =
      '${DateFormatComponents.year4Digit}/${DateFormatComponents.month2Digit}/${DateFormatComponents.day2Digit}';

  // Date Format: EEE, MMM d
  /// Formats as: Thu, Mar 6
  static const String weekdayMonthDay =
      '${DateFormatComponents.weekdayShortName}, ${DateFormatComponents.monthShortName} ${DateFormatComponents.dayOfMonth}';

  // Date Format: EEEE, MMMM d, yyyy
  /// Formats as: Tuesday, February 14, 2024
  static const String weekdayMonthDayYear4Digit =
      '${DateFormatComponents.weekdayFullName} ${DateFormatComponents.monthFullName} ${DateFormatComponents.dayOfMonth}, ${DateFormatComponents.year4Digit}';
}

abstract class TimeFormatString {
  /// Formats as: 1:00 PM
  static const String hourMinute12Hour =
      '${DateFormatComponents.hour12}:${DateFormatComponents.minute2Digit} ${DateFormatComponents.amPm}';

  // Time Format: hh:mm a
  /// Formats as: 01:00 PM
  static const String hourMinute12HourLeadingZero =
      '${DateFormatComponents.hour12LeadingZero}:${DateFormatComponents.minute2Digit} ${DateFormatComponents.amPm}';
}

abstract class DateTimeFormatStrings {
  // Formats as: 01/06/25, 1:00 PM
  static const String monthDayYearHourMinute12Hour =
      '${DateFormatStrings.monthDayYear}, ${TimeFormatString.hourMinute12Hour}';
}
