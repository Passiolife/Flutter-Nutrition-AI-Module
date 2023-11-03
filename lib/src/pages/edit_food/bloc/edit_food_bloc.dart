import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/util/passio_food_item_data_extension.dart';

part 'edit_food_event.dart';

part 'edit_food_state.dart';

class EditFoodBloc extends Bloc<EditFoodEvent, EditFoodState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector => NutritionAIModule.instance.configuration.connector;

  EditFoodBloc() : super(EditFoodInitial()) {
    on<DoAddIngredientsEvent>(_handleDoAddIngredientsEvent);
    on<DoRemoveIngredientsEvent>(_handleDoRemoveIngredientsEvent);
    on<DoUpdateIngredientEvent>(_handleDoUpdateIngredientEvent);
    on<DoFoodUpdateEvent>(_handleDoFoodUpdateEvent);
    on<DoFavouriteEvent>(_handleDoFavouriteEvent);
  }

  FutureOr<void> _handleDoAddIngredientsEvent(DoAddIngredientsEvent event, Emitter<EditFoodState> emit) async {
    final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.ingredientData?.passioID ?? '');
    if (attributes != null) {
      if (attributes.foodItem != null) {
        event.data?.addIngredients(ingredient: attributes.foodItem?.copyWith(passioID: attributes.passioID, name: attributes.name), isFirst: true);
        emit(AddIngredientsSuccessState());
      } else if (attributes.entityType == PassioIDEntityType.recipe) {
        attributes.recipe?.foodItems.forEach((element) {
          event.data?.addIngredients(ingredient: element, isFirst: true);
        });
        emit(AddIngredientsSuccessState());
      }
    }
  }

  FutureOr<void> _handleDoRemoveIngredientsEvent(DoRemoveIngredientsEvent event, Emitter<EditFoodState> emit) async {
    event.data?.removeIngredient(event.index) ?? false;
    emit(RemoveIngredientsState());
  }

  FutureOr<void> _handleDoUpdateIngredientEvent(DoUpdateIngredientEvent event, Emitter<EditFoodState> emit) async {
    if (event.updatedFoodItemData != null) {
      event.data?.replaceIngredient(event.updatedFoodItemData!, event.atIndex);
      emit(UpdateIngredientsSuccessState());
    }
  }

  Future<void> _handleDoFoodUpdateEvent(DoFoodUpdateEvent event, Emitter<EditFoodState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FoodUpdateFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }

      if (event.isFavorite) {
        await _connector.updateFavorite(foodRecord: foodRecord, isNew: false);
      } else {
        await _connector.updateRecord(foodRecord: foodRecord, isNew: false);
      }
      emit(FoodUpdateSuccessState());
    } catch (e) {
      emit(FoodUpdateFailureState(message: e.toString()));
    }
  }

  Future<void> _handleDoFavouriteEvent(DoFavouriteEvent event, Emitter<EditFoodState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FavoriteFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.updateFavorite(foodRecord: foodRecord, isNew: true);
      emit(FavoriteSuccessState());
    } catch (e) {
      emit(FavoriteFailureState(message: e.toString()));
    }
  }
}
