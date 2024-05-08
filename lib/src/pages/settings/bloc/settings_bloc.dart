import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/models/settings/settings.dart';
import '../../../common/util/local_notification.dart';
import '../../../common/util/user_session.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  UserProfileModel? _userProfileModel = UserSession.instance.userProfile;

  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  final _settings = Settings.instance;

  SettingsBloc() : super(SettingsInitial()) {
    on<GetUserProfileEvent>(_handleGetUserProfileEvent);
    on<GetRemindersEvent>(_handleGetRemindersEvent);
    on<DoUpdateHeightUnitEvent>(_handleDoUpdateHeightUnitEvent);
    on<DoUpdateWeightUnitEvent>(_handleDoUpdateWeightUnitEvent);
    on<DoUpdateMealReminderEvent>(_handleDoUpdateMealReminderEvent);
  }

  Future<void> _handleGetUserProfileEvent(
      GetUserProfileEvent event, Emitter<SettingsState> emit) async {
    _userProfileModel = UserSession.instance.userProfile;
    emit(GetUserProfileSuccessState(_userProfileModel));
  }

  Future<void> _handleGetRemindersEvent(
      GetRemindersEvent event, Emitter<SettingsState> emit) async {
    bool breakfastEnabled = _settings.getBreakfastReminder();
    bool lunchEnabled = _settings.getLunchReminder();
    bool dinnerEnabled = _settings.getDinnerReminder();
    emit(RemindersSuccessState(
      breakfastEnabled: breakfastEnabled,
      lunchEnabled: lunchEnabled,
      dinnerEnabled: dinnerEnabled,
    ));
  }

  Future<void> _handleDoUpdateHeightUnitEvent(
      DoUpdateHeightUnitEvent event, Emitter<SettingsState> emit) async {
    if (event.measurementSystem != null && _userProfileModel != null) {
      _userProfileModel?.heightUnit = event.measurementSystem!;
      await _connector.updateUserProfile(
          userProfile: _userProfileModel!, isNew: false);
    }
  }

  Future<void> _handleDoUpdateWeightUnitEvent(
      DoUpdateWeightUnitEvent event, Emitter<SettingsState> emit) async {
    if (event.measurementSystem != null && _userProfileModel != null) {
      _userProfileModel?.weightUnit = event.measurementSystem!;
      await _connector.updateUserProfile(
          userProfile: _userProfileModel!, isNew: false);
    }
  }

  Future<void> _handleDoUpdateMealReminderEvent(
      DoUpdateMealReminderEvent event, Emitter<SettingsState> emit) async {

    final isEnabled = event.enabled;
    final notificationTitle = event.title;
    final notificationDescription = event.description;
    final time = event.reminderTime;
    final mealTime = event.mealTime;
    final notificationId = MealLabel.values.indexOf(mealTime);

    if (isEnabled) {
      final now = DateTime.now();
      DateTime scheduleDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      if (scheduleDateTime.isBefore(now)) {
        scheduleDateTime = scheduleDateTime.add(const Duration(days: 1));
      }
      await _scheduleNotification(
        id: notificationId,
        title: notificationTitle,
        description: notificationDescription,
        time: scheduleDateTime,
      );
    } else {
      await _cancelNotification(notificationId);
    }
    _updateReminderState(mealTime, isEnabled);
    add(const GetRemindersEvent());
  }

  Future<bool> _scheduleNotification({
    required int id,
    required String title,
    required String description,
    required DateTime time,
  }) async {
    final timezone = await FlutterTimezone.getLocalTimezone();

    final localNotification = LocalNotificationManager();
    bool? isInitialized = await localNotification.init();
    if (isInitialized == null || !isInitialized) {
      return false;
    }
    bool? isScheduled = await localNotification.scheduleNotification(
      id: id,
      title: title,
      body: description,
      scheduledDateTime: time,
      timezoneName: timezone,
    );
    return isScheduled;
  }

  Future _cancelNotification(int id) async {
    final localNotification = LocalNotificationManager();
    await localNotification.cancel(id);
  }

  void _updateReminderState(MealLabel mealTime, bool enabled) {
    switch (mealTime) {
      case MealLabel.breakfast:
        _settings.setBreakfastReminder(enabled);
        break;
      case MealLabel.lunch:
        _settings.setLunchReminder(enabled);
        break;
      case MealLabel.dinner:
        _settings.setDinnerReminder(enabled);
        break;
      default:
        break;
    }
  }
}
