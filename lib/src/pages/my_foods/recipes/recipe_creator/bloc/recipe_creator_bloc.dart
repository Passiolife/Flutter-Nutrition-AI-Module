import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/domain/use_cases/food_logs/convert_food_data_info_to_food_record_use_case.dart';
import '../ui/model/navigation_data_provider.dart';
import '../ui/model/recipe_creator_view_model.dart';

part 'recipe_creator_event.dart';
part 'recipe_creator_state.dart';

class RecipeCreatorBloc extends Bloc<RecipeCreatorEvent, RecipeCreatorState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  RecipeCreatorViewModel viewModel = RecipeCreatorViewModel.empty();

  NavigationData? _navigationData;

  final ConvertFoodDataInfoToFoodRecordUseCase
      convertFoodDataInfoToFoodRecordUseCase;

  RecipeCreatorBloc({required this.convertFoodDataInfoToFoodRecordUseCase})
      : super(const RecipeCreatorInitial()) {
    on<DoUpdateImageEvent>(_handleUpdateImageEvent);
    on<DoUpdateRecipeNameEvent>(_handleDoUpdateRecipeNameEvent);
    on<DoUpdateQuantityEvent>(_handleDoQuantityUpdateEvent);
    on<DoUpdateIngredients>(_handleDoUpdateIngredients);
    on<DoUpdateVisibilityAddIngredientOptionsEvent>(
        _handleDoShowAddIngredientOptionsBuilderEvent);
    on<DoDeleteIngredientEvent>(_handleDoDeleteIngredientEvent);
    on<SaveRecipeEvent>(_handleSaveRecipeEvent);
    on<DoPrefillEvent>(_handleDoPrefillEvent);
    on<DoConvertIngredientEvent>(_handleDoConvertIngredient);
    on<DoUpdateUnitEvent>(_handleDoUpdateUnitEvent);
  }

  FutureOr<void> _handleUpdateImageEvent(
      DoUpdateImageEvent event, Emitter<RecipeCreatorState> emit) async {
    final image = event.image;
    viewModel = viewModel.doUpdateImage(image: image);
    emit(UpdateImageBuilderState(image: image));
  }

  FutureOr<void> _handleDoUpdateRecipeNameEvent(
      DoUpdateRecipeNameEvent event, Emitter<RecipeCreatorState> emit) async {
    final name = event.name.trim();
    viewModel = viewModel.doUpdateRecipeName(name: name);
    emit(UpdateRecipeNameBuilderState(name: name));
  }

  FutureOr<void> _handleDoUpdateUnitEvent(
      DoUpdateUnitEvent event, Emitter<RecipeCreatorState> emit) async {
    final unit = event.unit;
    viewModel = viewModel.doUpdateUnit(unit: unit);
    emit(UpdateUnitBuilderState(unit: unit));
  }

  FutureOr<void> _handleDoQuantityUpdateEvent(
      DoUpdateQuantityEvent event, Emitter<RecipeCreatorState> emit) async {
    final quantity = event.quantity;
    final fromSlider = event.fromSlider;
    viewModel =
        viewModel.doUpdateQuantity(quantity: quantity, fromSlider: fromSlider);
    emit(UpdateQuantityBuilderState(quantity: quantity));
  }

  FutureOr<void> _handleDoUpdateIngredients(
      DoUpdateIngredients event, Emitter<RecipeCreatorState> emit) async {
    final foodRecord = event.foodRecord;
    final isUpdate = event.isUpdate;
    final index = event.index;
    viewModel = viewModel.doUpdateIngredients(
      foodRecord: foodRecord,
      isUpdate: isUpdate,
      index: index,
    );
    emit(UpdateIngredientsBuilderState(foodRecord: foodRecord));
  }

  FutureOr<void> _handleDoShowAddIngredientOptionsBuilderEvent(
      DoUpdateVisibilityAddIngredientOptionsEvent event,
      Emitter<RecipeCreatorState> emit) {
    emit(ShowAddIngredientOptionsBuilderState(isVisible: event.isVisible));
  }

  FutureOr<void> _handleDoDeleteIngredientEvent(
      DoDeleteIngredientEvent event, Emitter<RecipeCreatorState> emit) {
    final index = event.index;
    viewModel = viewModel.doRemoveIngredient(index);
    emit(DeleteIngredientBuilderState(
        timestamp: DateTime.now().millisecondsSinceEpoch));
  }

  FutureOr<void> _handleSaveRecipeEvent(
      SaveRecipeEvent event, Emitter<RecipeCreatorState> emit) async {
    final finalViewModel = await viewModel.buildRecipe();
    final foodRecord = finalViewModel.foodRecord!;
    final image = finalViewModel.image;

    // Navigation Data
    final logUponCreate = _navigationData?.logUponCreate ?? false;
    final recipeFoodRecord = _navigationData?.recipeFoodRecord;
    final loggedFoodRecord = _navigationData?.loggedFoodRecord;
    final isNew = recipeFoodRecord == null;

    if (image != null) {
      await _connector.updateUserFoodImage(
        id: foodRecord.iconId,
        image: image,
        isNew: isNew,
      );
    }

    final id = await _connector.updateUserRecipe(
      foodRecord: foodRecord,
      isNew: isNew,
    );

    if (logUponCreate) {
      foodRecord.id = loggedFoodRecord?.id ?? '';
      foodRecord.refCode = '${FoodRecord.userRecipePrefix}$id';
      foodRecord
          .setCreatedAt(loggedFoodRecord?.getCreatedAt() ?? DateTime.now());
      foodRecord.mealLabel = loggedFoodRecord?.mealLabel;
      await _connector.updateRecord(foodRecord: foodRecord, isNew: false);
    }
    emit(SaveRecipeSuccessState(
        logUponCreate: logUponCreate, userRecipeRecord: recipeFoodRecord));
  }

  FutureOr<void> _handleDoPrefillEvent(
      DoPrefillEvent event, Emitter<RecipeCreatorState> emit) async {
    _navigationData = event.data;
    final recipeFoodRecord = _navigationData?.recipeFoodRecord;
    final loggedFoodRecord = _navigationData?.loggedFoodRecord;

    if (recipeFoodRecord == null && loggedFoodRecord == null) {
      return;
    }

    try {
      final foodRecord = recipeFoodRecord ?? loggedFoodRecord;
      final foodImage = (foodRecord?.iconIsUserRecipe ?? false)
          ? await _connector.fetchUserFoodImage(id: foodRecord!.iconId)
          : null;

      viewModel =
          await RecipeCreatorViewModel.fromRecord(foodRecord!, foodImage);

      emit(PrefillSuccessState(viewModel: viewModel));
    } catch (e) {}
  }

  FutureOr<void> _handleDoConvertIngredient(
      DoConvertIngredientEvent event, Emitter<RecipeCreatorState> emit) async {
    final foodDataInfo = event.foodDataInfo;
    final foodRecord = event.foodRecord;

    if (foodDataInfo != null) {
      final foodRecord = await convertFoodDataInfoToFoodRecordUseCase(
          foodDataInfo: foodDataInfo);
      if (foodRecord != null) {
        add(DoUpdateIngredients(foodRecord: foodRecord));
      }
    } else if (foodRecord != null) {
      add(DoUpdateIngredients(foodRecord: foodRecord));
    }
  }
}
