import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/util/command.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  List<FoodRecord>? userRecipes;

  RecipesBloc() : super(RecipesInitial()) {
    on<FetchUserRecipeEvent>(_handleFetchUserRecipeEvent);
    on<DoDeleteUserRecipeEvent>(_handleDoDeleteUserRecipeEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
  }

  Future<void> _handleFetchUserRecipeEvent(
      FetchUserRecipeEvent event, Emitter<RecipesState> emit) async {
    userRecipes = await _connector.fetchUserRecipes();
    emit(FetchUserRecipesSuccessState(recipes: userRecipes ?? []));
  }

  Future<void> _handleDoDeleteUserRecipeEvent(
      DoDeleteUserRecipeEvent event, Emitter<RecipesState> emit) async {
    await _connector.deleteUserRecipe(foodRecord: event.foodRecord);
    add(const FetchUserRecipeEvent());
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<RecipesState> emit) async {
    final foodRecord = event.foodRecord;
    foodRecord.logMeal();
    foodRecord.refCode = '${FoodRecord.userRecipePrefix}${foodRecord.id}';
    await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
    emit(const LogSuccessState());
  }
}
