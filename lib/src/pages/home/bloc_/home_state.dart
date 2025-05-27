part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object> get props => [];
}

final class UpdateHeaderState extends HomeState {
  const UpdateHeaderState({
    required this.userName,
    required this.selectedDate,
  });

  final DateTime selectedDate;
  final String userName;

  @override
  List<Object?> get props => [selectedDate, userName];
}

final class UpdateDailyNutritionState extends HomeState {
  const UpdateDailyNutritionState({
    required this.consumedCalories,
    required this.totalCalories,
    required this.consumedCarbs,
    required this.totalCarbs,
    required this.consumedProteins,
    required this.totalProteins,
    required this.consumedFat,
    required this.totalFat,
  });

  final int? consumedCalories;
  final double? totalCalories;
  final int? consumedCarbs;
  final double? totalCarbs;
  final int? consumedProteins;
  final double? totalProteins;
  final int? consumedFat;
  final double? totalFat;

  @override
  List<Object?> get props => [
        consumedCalories,
        totalCalories,
        consumedCarbs,
        totalCarbs,
        consumedProteins,
        totalProteins,
        consumedFat,
        totalFat,
      ];
}

final class UpdateWaterWeightState extends HomeState {
  const UpdateWaterWeightState({
    required this.consumedWater,
    required this.remainingWater,
    required this.measuredWeight,
    required this.remainingWeight,
    this.waterUnit,
    this.weightUnit,
  });

  final double measuredWeight;
  final double remainingWeight;
  final String? waterUnit;
  final double consumedWater;
  final double remainingWater;
  final String? weightUnit;

  @override
  List<Object?> get props => [
        weightUnit,
        measuredWeight,
        remainingWeight,
        waterUnit,
        consumedWater,
        remainingWater
      ];
}

final class UpdateWaterWeightErrorState extends HomeState {
  const UpdateWaterWeightErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class FetchRecordsErrorState extends HomeState {
  const FetchRecordsErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class UpdateWeeklyAdherenceState extends HomeState {
  const UpdateWeeklyAdherenceState({
    required this.selectedDate,
    required this.focusedDate,
    this.dayLogs,
  });

  final DateTime selectedDate;
  final DateTime focusedDate;
  final DayLogs? dayLogs;

  @override
  List<Object?> get props => [selectedDate, focusedDate, dayLogs];
}
