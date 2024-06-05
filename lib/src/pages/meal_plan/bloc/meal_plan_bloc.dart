import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/util/string_extensions.dart';

part 'meal_plan_event.dart';
part 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  MealPlanBloc() : super(const MealPlanInitial()) {
    on<DoDayUpdateEvent>(_handleOnDayUpdateEvent);
    on<DoFetchMealPlansEvent>(_handleDoFetchMealPlansEvent);
    on<DoFetchMealPlanForDayEvent>(_handleDoFetchMealPlanForDay);
    on<DoLogEntireMealEvent>(_handleDoLogEntireMealEvent);
    on<DoLogEvent>(_handleDoLogEvent);
  }

  Future<void> _handleOnDayUpdateEvent(
      DoDayUpdateEvent event, Emitter<MealPlanState> emit) async {
    emit(DayUpdateSuccessState(day: event.day));
  }

  Future<void> _handleDoFetchMealPlansEvent(
      DoFetchMealPlansEvent event, Emitter<MealPlanState> emit) async {
    final mealPlans = await NutritionAI.instance.fetchMealPlans();
    emit(FetchMealPlansSuccessState(data: mealPlans));
  }

  Future<void> _handleDoFetchMealPlanForDay(
      DoFetchMealPlanForDayEvent event, Emitter<MealPlanState> emit) async {
    emit(const FetchMealPlanItemsLoadingState());
    final mealPlanItems = await NutritionAI.instance
        .fetchMealPlanForDay(event.mealPlanLabel, event.day);
    emit(FetchMealPlanItemsSuccessState(data: mealPlanItems));
  }

  Future<void> _handleDoLogEntireMealEvent(
      DoLogEntireMealEvent event, Emitter<MealPlanState> emit) async {
    emit(const LogEntireMealLoadingState());

    await Future.forEach(
      event.data ?? <PassioFoodDataInfo>[],
      (element) async {
        PassioFoodItem? foodItem =
            await NutritionAI.instance.fetchFoodItemForDataInfo(element);
        if (foodItem != null) {
          final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
          bool hasUnit =
              foodRecord.setSelectedUnit(element.nutritionPreview.servingUnit);
          if (!hasUnit) {
            foodRecord.setSelectedUnit('gram');
          }
          foodRecord.setSelectedQuantity(hasUnit
              ? element.nutritionPreview.servingQuantity
              : element.nutritionPreview.weightQuantity);
          foodRecord.mealLabel = MealLabel.stringToMealLabel(
              event.mealTime?.name.toUpperCaseWord ?? '');
          await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
        }
      },
    );
    emit(const LogMealSuccessState());
  }

  Future<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<MealPlanState> emit) async {
    if (event.data == null) return;
    PassioFoodItem? foodItem =
        await NutritionAI.instance.fetchFoodItemForDataInfo(event.data!);
    if (foodItem != null) {
      final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      bool hasUnit = foodRecord
          .setSelectedUnit(event.data?.nutritionPreview.servingUnit ?? '');
      if (!hasUnit) {
        foodRecord.setSelectedUnit('gram');
      }
      foodRecord.setSelectedQuantity(hasUnit
          ? event.data?.nutritionPreview.servingQuantity ?? 1
          : event.data?.nutritionPreview.weightQuantity ?? 1);

      foodRecord.mealLabel = MealLabel.stringToMealLabel(
          event.mealTime?.name.toUpperCaseWord ?? '');

      await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
    }
    emit(LogSuccessState(createdAt: DateTime.now().millisecondsSinceEpoch));
  }
}
