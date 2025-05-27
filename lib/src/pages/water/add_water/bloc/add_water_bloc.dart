import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/domain/use_cases/passio_connector/update_water_use_case.dart';
import '../../../../common/extension/date_time_extension.dart';
import '../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../common/models/water_record/water_record.dart';
import '../../../../common/util/command.dart';
import '../../../../common/util/double_extensions.dart';
import '../../../../common/util/result.dart';

part 'add_water_event.dart';
part 'add_water_state.dart';

class AddWaterBloc extends Bloc<AddWaterEvent, AddWaterState> {
  final UpdateWaterUseCase _updateWaterUseCase;
  final UserProfileModel _userProfile;

  AddWaterBloc({
    required UpdateWaterUseCase updateWaterUseCase,
    required UserProfileModel userProfile,
  })  : _updateWaterUseCase = updateWaterUseCase,
        _userProfile = userProfile,
        super(const InitialState()) {
    on<InitialEvent>(_handleInitialEvent);
    on<UpdateWaterRecordEvent>(_handleUpdateWaterRecordEvent);
    on<UpdateWaterEvent>(_handleUpdateWaterEvent);
    on<UpdateDayEvent>(_handleUpdateDayEvent);
    on<UpdateTimeEvent>(_handleUpdateTimeEvent);
    on<SaveEvent>(_handleSaveEvent);
    on<SaveSuccessEvent>(_handleSaveSuccessEvent);
    on<SaveFailureEvent>(_handleSaveFailureEvent);

    add(const InitialEvent());
  }

  late final Command0 saveCommand = Command0(_doSave);

  MeasurementSystem _unit = MeasurementSystem.imperial;
  String _unitSymbol = 'oz';

  String get unitSymbol => _unitSymbol;

  DateTime _createdAt = DateTime.now();

  DateTime get createdAt => _createdAt;

  String get day =>
      _createdAt.formatToStringNew(DateFormatStrings.weekdayMonthDayYear4Digit);

  String get time => _createdAt
      .formatToStringNew(TimeFormatString.hourMinute12HourLeadingZero);

  late double _water;

  double get water => _water;

  WaterRecord? _waterRecord;

  WaterRecord? get waterRecord => _waterRecord;

  bool get isNew => _waterRecord?.id == null;

  void _handleInitialEvent(InitialEvent event, Emitter<AddWaterState> emit) {
    _unit = _userProfile.weightUnit;
    _unitSymbol = _unit == MeasurementSystem.imperial ? 'oz' : 'ml';
    emit(UpdateUnitSymbolState(unitSymbol: _unitSymbol));
    emit(UpdateDayState(dateTime: createdAt));
    emit(UpdateTimeState(dateTime: createdAt));
  }

  void _handleUpdateWaterRecordEvent(
      UpdateWaterRecordEvent event, Emitter<AddWaterState> emit) {
    _waterRecord = event.record;
    add(UpdateWaterEvent(
        water: waterRecord!.getWater(unit: _unit).toString()));
    add(UpdateDayEvent(
        date: DateTime.fromMillisecondsSinceEpoch(waterRecord!.createdAt)));
    add(UpdateTimeEvent(
        time: TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(waterRecord!.createdAt))));
    emit(UpdateActionButtonState(isNew: isNew));
  }

  void _handleUpdateWaterEvent(
      UpdateWaterEvent event, Emitter<AddWaterState> emit) {
    _water = double.tryParse(event.water) ?? 0;
    emit(UpdateWaterState(water: water.format()));
  }

  void _handleUpdateDayEvent(
      UpdateDayEvent event, Emitter<AddWaterState> emit) {
    _createdAt = _createdAt.copyWith(
      year: event.date.year,
      month: event.date.month,
      day: event.date.day,
    );
    emit(UpdateDayState(dateTime: createdAt));
  }

  void _handleUpdateTimeEvent(
      UpdateTimeEvent event, Emitter<AddWaterState> emit) {
    _createdAt = _createdAt.copyWith(
      hour: event.time.hour,
      minute: event.time.minute,
    );
    emit(UpdateTimeState(dateTime: createdAt));
  }

  Future<void> _handleSaveEvent(
      SaveEvent event, Emitter<AddWaterState> emit) async {
    await saveCommand.execute();
  }

  Future<Result<void>> _doSave() async {
    try {
      if (_waterRecord == null) {
        _waterRecord =
            WaterRecord(createdAt: _createdAt.millisecondsSinceEpoch);
      } else {
        _waterRecord =
            _waterRecord!.copyWith(
                createdAt: _createdAt.millisecondsSinceEpoch);
      }
      _waterRecord?.setWater(water, _unit);
      final Result<void> result = await _updateWaterUseCase
          .call(UpdateWaterParams(waterRecord: waterRecord!, isNew: isNew));

      switch (result) {
        case Error<void>():
          add(SaveFailureEvent(error: result.error.toString()));
          return result;
        case Success<void>():
      }
      add(const SaveSuccessEvent());
      return result;
    } finally {
      saveCommand.clearResult();
    }
  }

  void _handleSaveSuccessEvent(
      SaveSuccessEvent event, Emitter<AddWaterState> emit) {
    emit(const SaveSuccessState());
  }

  void _handleSaveFailureEvent(
      SaveFailureEvent event, Emitter<AddWaterState> emit) {
    emit(SaveFailureState(error: event.error));
  }
}
