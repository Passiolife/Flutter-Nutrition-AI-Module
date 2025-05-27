import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/domain/use_cases/passio_connector/delete_user_food_record_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/fetch_user_foods_use_case.dart';
import '../../../common/domain/use_cases/use_case.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/command.dart';
import '../../../common/util/result.dart';

part 'custom_foods_event.dart';
part 'custom_foods_state.dart';

class CustomFoodsBloc extends Bloc<CustomFoodsEvent, CustomFoodsState> {
  final FetchUserFoodsUseCase _fetchUserFoodsUseCase;
  final DeleteUserFoodRecordUseCase _deleteUserFoodRecordUseCase;

  CustomFoodsBloc({required FetchUserFoodsUseCase fetchUserFoodsUseCase, required DeleteUserFoodRecordUseCase deleteUserFoodRecordUseCase})
      : _fetchUserFoodsUseCase = fetchUserFoodsUseCase, _deleteUserFoodRecordUseCase = deleteUserFoodRecordUseCase,
        super(const InitialState()) {
    on<FetchUserFoodsEvent>(_handleFetchUserFoodsEvent);
    on<FetchSuccessEvent>(_handleFetchSuccessEvent);
    on<FetchErrorEvent>(_handleFetchErrorEvent);
    on<DeleteFoodEvent>(_handleDeleteFoodEvent);
    on<DeleteUserFoodRecordSuccessEvent>(_handleDeleteUserFoodRecordSuccessEvent);
    on<DeleteUserFoodRecordErrorEvent>(_handleDeleteUserFoodRecordErrorEvent);

    _loadCommand = Command0(_fetchFoods);
    _deleteCommand = Command1<void, int>(_deleteFoodRecord);
    add(const FetchUserFoodsEvent());
  }

  late Command0 _loadCommand;
  List<FoodRecord> _customFoods = <FoodRecord>[];
  List<FoodRecord> get customFoods => _customFoods;

  late Command1<void, int> _deleteCommand;

  FutureOr<void> _handleFetchUserFoodsEvent(
      FetchUserFoodsEvent event, Emitter<CustomFoodsState> emit) async {
    await _loadCommand.execute();
  }

  Future<Result<List>> _fetchFoods() async {
    try {
      final Result<List<FoodRecord>> result = await _fetchUserFoodsUseCase.call(const NoParams());
      switch (result) {
        case Error<List<FoodRecord>>():
          add(FetchErrorEvent(result.error.toString()));
          return result;
        case Success<List<FoodRecord>>():
      }
      add(FetchSuccessEvent(result.value));
      return result;
    } finally {
      _loadCommand.clearResult();
    }
  }

  FutureOr<void> _handleFetchSuccessEvent(
      FetchSuccessEvent event, Emitter<CustomFoodsState> emit) async {
    _customFoods = event.data;
    emit(FetchSuccessState(data: _customFoods));
  }

  FutureOr<void> _handleFetchErrorEvent(
      FetchErrorEvent event, Emitter<CustomFoodsState> emit) async {
    emit(FetchErrorState(error: event.error));
  }

  FutureOr<void> _handleDeleteFoodEvent(
      DeleteFoodEvent event, Emitter<CustomFoodsState> emit) async {
    await _deleteCommand.execute(event.index);
  }

  Future<Result<void>> _deleteFoodRecord(int index) async {
    try {
      final List<FoodRecord> newList = List.from(_customFoods);
      final FoodRecord record = newList.removeAt(index);
      add(FetchSuccessEvent(newList));

      final Result<void> result = await _deleteUserFoodRecordUseCase.call(DeleteUserFoodRecordParams(record: record));
      switch(result) {
        case Error<void>():
          add(DeleteUserFoodRecordErrorEvent(error: result.error.toString()));
          return result;
        case Success<void>():
      }
      add(const DeleteUserFoodRecordSuccessEvent());
      return result;
    } finally {
      _deleteCommand.clearResult();
    }
  }

  FutureOr<void> _handleDeleteUserFoodRecordSuccessEvent(
      DeleteUserFoodRecordSuccessEvent event, Emitter<CustomFoodsState> emit) async {
    emit(const DeleteUserFoodRecordSuccessState());
  }

  FutureOr<void> _handleDeleteUserFoodRecordErrorEvent(
      DeleteUserFoodRecordErrorEvent event, Emitter<CustomFoodsState> emit) async {
    emit(DeleteUserFoodRecordErrorState(error: event.error));
  }
}
