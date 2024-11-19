import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_constants.dart';

part 'custom_foods_event.dart';
part 'custom_foods_state.dart';

class CustomFoodsBloc extends Bloc<CustomFoodsEvent, CustomFoodsState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  CustomFoodsBloc() : super(CustomFoodsInitial()) {
    on<FetchUserFoodsEvent>(_handleFetchUserFoodsEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
    on<DoUpdateUserFoodEvent>(_handleDoUpdateUserFoodEvent);
    on<DoDeleteUserFoodEvent>(_handleDoDeleteUserFoodEvent);
  }

  FutureOr<void> _handleFetchUserFoodsEvent(
      FetchUserFoodsEvent event, Emitter<CustomFoodsState> emit) async {
    final records = await _connector.fetchUserFoods();
    emit(FetchUserFoodsListenerState(data: records));
    emit(const FetchUserFoodsBuilderState());
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<CustomFoodsState> emit) async {
    final foodRecord = event.foodRecord;
    foodRecord.logMeal();
    foodRecord.sourceId = '${AppCommonConstants.userFoods}${foodRecord.id}';
    await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
    emit(const LogSuccessState());
  }

  Future<void> _handleDoUpdateUserFoodEvent(
      DoUpdateUserFoodEvent event, Emitter<CustomFoodsState> emit) async {
    await _connector.updateUserFood(foodRecord: event.foodRecord, isNew: false);
  }

  FutureOr<void> _handleDoDeleteUserFoodEvent(
      DoDeleteUserFoodEvent event, Emitter<CustomFoodsState> emit) async {
    await _connector.deleteUserFood(foodRecord: event.foodRecord);
    add(const FetchUserFoodsEvent());
  }
}
