part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
}

final class GetUserProfileEvent extends SettingsEvent {
  const GetUserProfileEvent();

  @override
  List<Object?> get props => [];
}

final class GetRemindersEvent extends SettingsEvent {
  const GetRemindersEvent();

  @override
  List<Object?> get props => [];
}

final class DoUpdateHeightUnitEvent extends SettingsEvent {
  const DoUpdateHeightUnitEvent({required this.measurementSystem});

  final MeasurementSystem? measurementSystem;

  @override
  List<Object?> get props => [measurementSystem];
}

final class DoUpdateWeightUnitEvent extends SettingsEvent {
  const DoUpdateWeightUnitEvent({required this.measurementSystem});

  final MeasurementSystem? measurementSystem;

  @override
  List<Object?> get props => [measurementSystem];
}

final class DoUpdateMealReminderEvent extends SettingsEvent {
  final bool enabled;
  final String title;
  final String description;
  final TimeOfDay reminderTime;
  final MealLabel mealTime;

  const DoUpdateMealReminderEvent({
    required this.enabled,
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.mealTime,
  });

  @override
  List<Object?> get props => [
        enabled,
        title,
        description,
        reminderTime,
        mealTime,
      ];
}
