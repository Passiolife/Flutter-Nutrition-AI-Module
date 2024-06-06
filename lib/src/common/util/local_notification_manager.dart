import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class LocalNotificationManager {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final LocalNotificationManager _instance =
      LocalNotificationManager._();

  LocalNotificationManager._();

  factory LocalNotificationManager() => _instance;

  Future<bool?> init({String androidIcon = '@mipmap/ic_launcher'}) async {
    // Initialize Android notification settings with icon
    var androidInitializationSettings =
        AndroidInitializationSettings(androidIcon);

    // Initialize iOS notification settings
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    // Combine Android and iOS initialization settings
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    // Initialize the flutterLocalNotificationsPlugin with the combined settings
    return await _flutterLocalNotificationsPlugin
        .initialize(initializationSettings);
  }

  NotificationDetails _getNotificationDetails({
    AndroidNotificationDetails? androidDetails,
    DarwinNotificationDetails? iOSDetails,
  }) {
    return NotificationDetails(
      android: androidDetails ??
          const AndroidNotificationDetails(
            'meal_reminders_channel',
            'Meal Reminders',
            channelDescription:
                'Get reminders for your breakfast, lunch, and dinner.',
            importance: Importance.high,
          ),
      iOS: iOSDetails ??
          const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
    );
  }

  Future<void> show() async {
    String title = 'Title';
    String body = 'Body';
    // String data = 'Data';

    final details = _getNotificationDetails();

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
    );
  }

  Future<void> cancel(int id, {String? tag}) async {
    return await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    return await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? timezoneName,
    required DateTime scheduledDateTime,
  }) async {
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
    }
    if (timezoneName != null) {
      timezone.initializeTimeZones();
      timezone.setLocalLocation(timezone.getLocation(timezoneName));
    }
    final details = _getNotificationDetails();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      timezone.TZDateTime.from(scheduledDateTime, timezone.local),
      details,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    return true;
  }

  Future periodicallyNotifications({
    int id = 0,
    String? title,
    String? body,
    String? timezoneName,
    required DateTime scheduledDateTime,
  }) async {
    _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      _getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
