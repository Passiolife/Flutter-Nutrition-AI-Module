import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/domain/use_cases/passio_connector/delete_water_record_use_case.dart';
import '../../../../common/domain/use_cases/passio_connector/fetch_water_records_use_case.dart';
import '../../../../common/domain/use_cases/passio_connector/update_water_use_case.dart';
import '../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../common/models/water_day_logs/water_day_logs.dart';
import '../../../../common/models/water_record/water_record.dart';
import '../../../../common/util/command.dart';
import '../../../../common/util/date_time_utility.dart';
import '../../../../common/util/result.dart';
import '../models/water_chart_data.dart';

part 'water_event.dart';
part 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final UserProfileModel _userProfile;
  final FetchWaterRecordsUseCase _fetchWaterRecordsUseCase;
  final UpdateWaterUseCase _updateWaterUseCase;
  final DeleteWaterRecordUseCase _deleteWaterRecordUseCase;

  WaterBloc({
    required UserProfileModel userProfile,
    required FetchWaterRecordsUseCase fetchWaterRecordsUseCase,
    required UpdateWaterUseCase updateWaterUseCase,
    required DeleteWaterRecordUseCase deleteWaterRecordUseCase,
  })  : _userProfile = userProfile,
        _fetchWaterRecordsUseCase = fetchWaterRecordsUseCase,
        _updateWaterUseCase = updateWaterUseCase,
        _deleteWaterRecordUseCase = deleteWaterRecordUseCase,
        super(const InitialState()) {
    on<UpdateTabEvent>(_handleUpdateTabEvent);
    on<UpdatePageEvent>(_handleUpdatePageEvent);
    on<UpdateQuickAddEvent>(_handleUpdateQuickAddEvent);
    on<UpdateDateRangeEvent>(_handleUpdateDateRangeEvent);
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<FetchRecordsFailureEvent>(_handleFetchRecordsFailureEvent);
    on<QuickAddEvent>(_handleQuickAddEvent);
    on<QuickAddSuccessEvent>(_handleQuickAddSuccessEvent);
    on<QuickAddFailureEvent>(_handleQuickAddFailureEvent);
    on<UpdateWaterTrendEvent>(_handleUpdateWaterTrendEvent);
    on<DeleteWaterEvent>(_handleDeleteWaterEvent);
    on<DeleteWaterFailureEvent>(_handleDeleteWaterFailureEvent);
    on<UpdateRecordsEvent>(_handleUpdateRecordsEvent);

    _loadCommand = Command0<void>(_fetchWaterRecords);
    _quickAddCommand = Command1<void, double>(_quickAdd);
    _deleteCommand = Command1<void, WaterRecord>(_deleteWaterRecord);

    _waterTarget = _userProfile.getTargetWater() ?? 0;
    add(const UpdateQuickAddEvent());
  }

  late final Command0<void> _loadCommand;
  late final Command1<void, double> _quickAddCommand;
  late final Command1<void, WaterRecord> _deleteCommand;

  double _waterTarget = 0;

  double get chartMaximumValue =>
      _dayLogs.dayLog.fold<double>(0, (previous, element) {
        final current = element.getConsumedWater(_unit);
        return previous > current ? previous : current;
      });

  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  //
  static const double _glassValueInMl = 236.588;
  static const double _smallBottleValueInMl = 473.176;
  static const double _largeBottleValueInMl = 709.765;

  double _glassValue = 0;

  double get glassValue => _glassValue;
  double _smallBottleValue = 0;

  double get smallBottleValue => _smallBottleValue;
  double _largeBottleValue = 0;

  double get largeBottleValue => _largeBottleValue;
  late MeasurementSystem _unit;
  String _unitSymbol = '';

  String get unitSymbol => _unitSymbol;

  List<WaterRecord> _waterRecords = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  late WaterDayLogs _dayLogs;

  List<WaterChartData> get _chartData => _dayLogs.dayLog
      .map((e) => WaterChartData(
            (_selectedTab == 0)
                ? e.date.formatToString(format10).substring(0, 2)
                : e.date.formatToString(format16),
            e.getConsumedWater(_userProfile.weightUnit),
          ))
      .toList();
  double _maximumValue = 0;

  void _handleUpdateTabEvent(UpdateTabEvent event, Emitter<WaterState> emit) {
    _selectedTab = event.tab;
    emit(UpdateTabState(tab: _selectedTab));
  }

  void _handleUpdateQuickAddEvent(
      UpdateQuickAddEvent event, Emitter<WaterState> emit) {
    _unit = _userProfile.weightUnit;
    _unitSymbol = _unit == MeasurementSystem.imperial ? 'oz' : 'ml';

    double conversion =
        _unit == MeasurementSystem.imperial ? Conversion.mlToOz.value : 1;
    _glassValue = _glassValueInMl * conversion;
    _smallBottleValue = _smallBottleValueInMl * conversion;
    _largeBottleValue = _largeBottleValueInMl * conversion;

    emit(UpdateQuickAddState(
      glassValue: _glassValue,
      smallBottleValue: _smallBottleValue,
      largeBottleValue: _largeBottleValue,
      unitSymbol: _unitSymbol,
    ));
  }

  Future<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<WaterState> emit) async {
    await _loadCommand.execute();
  }

  void _handleFetchRecordsFailureEvent(
      FetchRecordsFailureEvent event, Emitter<WaterState> emit) {
    emit(FetchRecordsFailureState(error: event.error));
  }

  Future<Result<List<WaterRecord>>> _fetchWaterRecords() async {
    try {
      final Result<List<WaterRecord>> result = await _fetchWaterRecordsUseCase
          .call(FetchWaterRecordsParams(fromDate: startDate, endDate: endDate));

      switch (result) {
        case Error<List<WaterRecord>>():
          add(FetchRecordsFailureEvent(error: result.error.toString()));
          return result;
        case Success<List<WaterRecord>>():
      }
      _dayLogs = WaterDayLogs.from(result.value);
      _dayLogs.fromDates(startDate.getDatesBetween(endDate: endDate));
      _waterRecords = _dayLogs.dayLog.expand((element) {
        return element.records;
      }).toList()
        ..sort((a, b) {
          final aId = a.id;
          final bId = b.id;
          if (aId == null || bId == null) {
            return 0;
          }
          return bId.compareTo(aId);
        });

      add(const UpdateRecordsEvent());
      add(const UpdateWaterTrendEvent());

      return result;
    } finally {
      _loadCommand.clearResult();
    }
  }

  void _handleUpdateRecordsEvent(
      UpdateRecordsEvent event, Emitter<WaterState> emit) {
    emit(UpdateRecordsState(
      records: _waterRecords,
      unitSymbol: _unitSymbol,
      unit: _unit,
      startDate: startDate,
      endDate: endDate,
      isMonthRange: _selectedTab == 1,
      // time: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<void> _handleQuickAddEvent(
      QuickAddEvent event, Emitter<WaterState> emit) async {
    final double volume = event.consumedWater;
    await _quickAddCommand.execute(volume);
  }

  void _handleQuickAddSuccessEvent(
      QuickAddSuccessEvent event, Emitter<WaterState> emit) {
    emit(const QuickAddSuccessState());
  }

  void _handleQuickAddFailureEvent(
      QuickAddFailureEvent event, Emitter<WaterState> emit) {
    emit(QuickAddFailureState(error: event.error));
  }

  Future<Result<void>> _quickAdd(double volume) async {
    try {
      int createdAt = DateTime
          .now()
          .toUtc()
          .millisecondsSinceEpoch;
      WaterRecord waterRecord = WaterRecord(createdAt: createdAt)
        ..setWater(volume, _unit);
      final Result<void> result = await _updateWaterUseCase
          .call(UpdateWaterParams(waterRecord: waterRecord, isNew: true));

      switch(result) {
        case Error<void>():
          add(QuickAddFailureEvent(error: result.error.toString()));
          return result;
        case Success<void>():
      }
      add(const QuickAddSuccessEvent());
      add(const FetchRecordsEvent());
      return result;
    } finally {
      _quickAddCommand.clearResult();
    }
  }

  void _handleUpdateDateRangeEvent(
      UpdateDateRangeEvent event, Emitter<WaterState> emit) {
    startDate = event.startDate;
    endDate = event.endDate;
    add(const FetchRecordsEvent());
  }

  void _handleUpdatePageEvent(UpdatePageEvent event, Emitter<WaterState> emit) {
    _selectedTab = event.page;
    emit(UpdatePageState(page: _selectedTab));
  }

  void _handleUpdateWaterTrendEvent(
      UpdateWaterTrendEvent event, Emitter<WaterState> emit) {
    _maximumValue = math.max(math.max(chartMaximumValue, _waterTarget), 5);

    emit(UpdateWaterTrendState(
      chartData: _chartData,
      maximumValue: _maximumValue,
      targetValue: _waterTarget,
    ));
  }

  Future<void> _handleDeleteWaterEvent(
      DeleteWaterEvent event, Emitter<WaterState> emit) async {
    final WaterRecord record = event.record;
    await _deleteCommand.execute(record);
  }

  void _handleDeleteWaterFailureEvent(
      DeleteWaterFailureEvent event, Emitter<WaterState> emit) {
    emit(DeleteWaterFailureState(error: event.error));
  }

  Future<Result<void>> _deleteWaterRecord(WaterRecord record) async {
    try {
      final Result<void> result = await _deleteWaterRecordUseCase
          .call(DeleteWaterRecordParams(record: record));
      switch(result) {
        case Error<void>():
          add(DeleteWaterFailureEvent(error: result.error.toString()));
          return result;
        case Success<void>():
      }
      add(const FetchRecordsEvent());
      return result;
    } finally {
      _deleteCommand.clearResult();
    }
  }
}
