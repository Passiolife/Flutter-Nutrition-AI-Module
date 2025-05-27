import 'dart:async';
import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/domain/use_cases/passio_connector/fetch_consumed_water_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/fetch_day_logs_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/fetch_measured_weight_use_case.dart';
import '../../../common/extension/date_time_extension.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/day_logs/day_logs.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/result.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchDayLogsUseCase _fetchDayLogsUseCase;
  final FetchMeasuredWeightUseCase _fetchMeasuredWeightUseCase;
  final FetchConsumedWaterUseCase _fetchConsumedWaterUseCase;
  final UserProfileModel _profileModel;

  //
  String _userName = '';
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  late DateTime _startDate = DateTime.now();
  late DateTime _endDate = DateTime.now();
  DayLogs? _dayLogs;

  // Weight Water Section
  String? _waterUnit;
  double _consumedWater = 0;
  double _remainingWater = 0;
  String? _weightUnit;
  double _measuredWeight = 0;
  double _remainingWeight = 0;

  // Daily Nutrition
  int? _consumedCalories;
  double? _totalCalories;
  int? _consumedCarbs;
  double? _totalCarbs;
  int? _consumedProteins;
  double? _totalProteins;
  int? _consumedFat;
  double? _totalFat;

  HomeBloc({
    required FetchDayLogsUseCase fetchDayLogsUseCase,
    required FetchMeasuredWeightUseCase fetchMeasuredWeightUseCase,
    required FetchConsumedWaterUseCase fetchConsumedWaterUseCase,
    required UserProfileModel profileModel,
  })  : _fetchDayLogsUseCase = fetchDayLogsUseCase,
        _fetchMeasuredWeightUseCase = fetchMeasuredWeightUseCase,
        _fetchConsumedWaterUseCase = fetchConsumedWaterUseCase,
        _profileModel = profileModel,
        super(const HomeInitial()) {
    on<HomeInitialEvent>(_handleHomeInitialEvent);
    on<UpdateDateEvent>(_handleUpdateDateEvent);
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<UpdateWeightEvent>(_handleUpdateWeightEvent);
    on<UpdateWaterEvent>(_handleUpdateWaterEvent);
    on<UpdateDailyNutritionEvent>(_handleUpdateDailyNutritionEvent);
    on<UpdateWeeklyAdherenceEvent>(_handleUpdateWeeklyAdherenceEvent);

    add(const HomeInitialEvent());
  }

  FutureOr<void> _handleUpdateWeeklyAdherenceEvent(
      UpdateWeeklyAdherenceEvent event, Emitter<HomeState> emit) async {
    final DateTime focusedDate = event.focusedDate;
    final DateTime startDate = event.startDate;
    final DateTime endDate = event.endDate;
    if (focusedDate == _focusedDate && _startDate == startDate && endDate == _endDate) {
      add(const UpdateDailyNutritionEvent());
      return;
    }
    _focusedDate = focusedDate;
    _startDate = startDate;
    _endDate = endDate;
    add(const FetchRecordsEvent());
  }

  FutureOr<void> _handleHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    _selectedDate = DateTime.now();
    _focusedDate = DateTime.now();
    _userName = _profileModel.name ?? '';

    add(UpdateDateEvent(_selectedDate));

    add(const UpdateWeightEvent());
    add(const UpdateWaterEvent());
  }

  FutureOr<void> _handleUpdateDailyNutritionEvent(
      UpdateDailyNutritionEvent event, Emitter<HomeState> emit) {
    final String formattedSelectedDate =
        _selectedDate.formatToStringNew(DateFormatStrings.yearMonthDay);

    final DayLog? dayLog = _dayLogs?.dayLog.cast<DayLog?>().firstWhere(
          (log) =>
              log?.date.formatToStringNew(DateFormatStrings.yearMonthDay) ==
              formattedSelectedDate,
          orElse: () => null,
        );

    _consumedCalories = dayLog?.consumedCalories.round();
    _totalCalories = _profileModel.caloriesTarget.toDouble();
    _consumedCarbs = dayLog?.consumedCarbs.round();
    _totalCarbs = _profileModel.caloriesTarget.toDouble();
    _consumedProteins = dayLog?.consumedProteins.round();
    _totalProteins = _profileModel.caloriesTarget.toDouble();
    _consumedFat = dayLog?.consumedFat.round();
    _totalFat = _profileModel.caloriesTarget.toDouble();
    emit(UpdateDailyNutritionState(
      consumedCalories: _consumedCalories,
      totalCalories: _totalCalories,
      consumedCarbs: _consumedCarbs,
      totalCarbs: _totalCarbs,
      consumedProteins: _consumedProteins,
      totalProteins: _totalProteins,
      consumedFat: _consumedFat,
      totalFat: _totalFat,
    ));
  }

  FutureOr<void> _handleUpdateDateEvent(
      UpdateDateEvent event, Emitter<HomeState> emit) async {
    _selectedDate = event.date;
    add(const UpdateWaterEvent());
    add(const UpdateWeightEvent());
    emit(UpdateWeeklyAdherenceState(
      focusedDate: _focusedDate,
      selectedDate: _selectedDate,
      dayLogs: _dayLogs,
    ));
    emit(UpdateHeaderState(userName: _userName, selectedDate: _selectedDate));
  }

  FutureOr<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<HomeState> emit) async {
    final result = await _fetchDayLogsUseCase
        .call(Params(fromDate: _startDate, endDate: _endDate));
    switch (result) {
      case Success():
        _dayLogs = result.value;
        break;
      case Error():
        emit(FetchRecordsErrorState(error: result.error.toString()));
        return;
    }

    emit(UpdateWeeklyAdherenceState(
      focusedDate: _focusedDate,
      selectedDate: _selectedDate,
      dayLogs: _dayLogs,
    ));
    add(const UpdateDailyNutritionEvent());
  }

  FutureOr<void> _handleUpdateWeightEvent(
      UpdateWeightEvent event, Emitter<HomeState> emit) async {
    final result = await _fetchMeasuredWeightUseCase
        .call(FetchMeasuredWeightParams(dateTime: _selectedDate));
    switch (result) {
      case Success():
        _updateWeight(result.value);
        emit(UpdateWaterWeightState(
          weightUnit: _weightUnit,
          measuredWeight: _measuredWeight,
          remainingWeight: _remainingWeight,
          waterUnit: _waterUnit,
          consumedWater: _consumedWater,
          remainingWater: _remainingWater,
        ));
        break;
      case Error():
        emit(UpdateWaterWeightErrorState(error: result.error.toString()));
        break;
    }
  }

  void _updateWeight(double weight) {
    _weightUnit = _profileModel.weightUnit == MeasurementSystem.imperial
        ? WeightUnits.lbs.name
        : WeightUnits.kg.name;
    _measuredWeight = (_profileModel.weightUnit == MeasurementSystem.imperial
            ? weight * Conversion.kgToLbs.value
            : weight)
        .parseFormatted();
    _remainingWeight = math.max(
        0, _profileModel.getTargetWeight().parseFormatted() - _measuredWeight);
  }

  Future<void> _handleUpdateWaterEvent(
      UpdateWaterEvent event, Emitter<HomeState> emit) async {
    final result = await _fetchConsumedWaterUseCase
        .call(FetchConsumedWaterParams(dateTime: _selectedDate));
    switch (result) {
      case Success():
        _updateWater(result.value);
        emit(UpdateWaterWeightState(
          measuredWeight: _measuredWeight,
          remainingWeight: _remainingWeight,
          waterUnit: _waterUnit,
          consumedWater: _consumedWater,
          remainingWater: _remainingWater,
          weightUnit: _weightUnit,
        ));
        break;
      case Error():
        emit(UpdateWaterWeightErrorState(error: result.error.toString()));
        break;
    }
  }

  void _updateWater(double water) {
    _waterUnit = _profileModel.weightUnit == MeasurementSystem.imperial
        ? WaterUnits.oz.name
        : WaterUnits.ml.name;
    _consumedWater = (_profileModel.weightUnit == MeasurementSystem.imperial
            ? water * Conversion.mlToOz.value
            : water)
        .parseFormatted();
    _remainingWater = math.max(
        0, _profileModel.getTargetWater().parseFormatted() - _consumedWater);
  }
}
