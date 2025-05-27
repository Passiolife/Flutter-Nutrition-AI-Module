import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart' as nutrition_ai;

import '../../../common/domain/use_cases/passio_connector/fetch_user_food_image_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/update_user_food_image_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/update_user_food_use_case.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/models/key_value_model.dart';
import '../../../common/util/command.dart';
import '../../../common/util/result.dart';
import '../models/food_creator_model.dart';

part 'food_creator_event.dart';
part 'food_creator_state.dart';

class FoodCreatorBloc extends Bloc<FoodCreatorEvent, FoodCreatorState> {
  final UpdateUserFoodUseCase _updateUserFoodUseCase;
  final UpdateUserFoodImageUseCase _updateUserFoodImageUseCase;
  final FetchUserFoodImageUseCase _fetchUserFoodImageUseCase;

  FoodCreatorBloc({
    required UpdateUserFoodUseCase updateUserFoodUseCase,
    required UpdateUserFoodImageUseCase updateUserFoodImageUseCase,
    required FetchUserFoodImageUseCase fetchUserFoodImageUseCase,
  })  : _updateUserFoodUseCase = updateUserFoodUseCase,
        _updateUserFoodImageUseCase = updateUserFoodImageUseCase,
        _fetchUserFoodImageUseCase = fetchUserFoodImageUseCase,
        super(const InitialState()) {
    on<DoConversionEvent>(_doConversionEvent);
    on<UpdateImageEvent>(_handleUpdateImageEvent);
    on<UpdateNameEvent>(_handleUpdateNameEvent);
    on<UpdateBrandEvent>(_handleUpdateBrandEvent);
    on<UpdateFoodDetailsEvent>(_handleUpdateFoodDetailsEvent);
    on<UpdateServingSizeEvent>(_handleUpdateServingSizeEvent);
    on<UpdateUnitEvent>(_handleUpdateUnitEvent);
    on<UpdateWeightEvent>(_handleUpdateWeightEvent);
    on<UpdateWeightSymbolEvent>(_handleUpdateWeightSymbolEvent);
    on<UpdateCaloriesEvent>(_handleUpdateCaloriesEvent);
    on<UpdateCarbsEvent>(_handleUpdateCarbsEvent);
    on<UpdateFatEvent>(_handleUpdateFatEvent);
    on<UpdateProteinEvent>(_handleUpdateProteinEvent);
    on<SelectOtherNutritionFactsEvent>(_handleSelectOtherNutritionFactsEvent);
    on<UpdateOtherNutritionFactsEvent>(_handleUpdateOtherNutritionFactsEvent);
    on<RemoveOtherNutritionFactsEvent>(_handleRemoveOtherNutritionFactsEvent);
    on<SubmitUserCreatedFoodEvent>(_handleSubmitUserCreatedFoodEvent);
    on<SaveSuccessEvent>(_handleSaveSuccessEvent);
    on<SaveErrorEvent>(_handleSaveErrorEvent);
    on<UpdateBarcodeEvent>(_handleUpdateBarcodeEvent);

    _saveCommand = Command0(_saveFood);
  }

  late Command0 _saveCommand;

  Command0 get saveCommand => _saveCommand;

  late FoodCreatorModel _creatorModel = FoodCreatorModel();

  FoodCreatorModel get creatorModel => _creatorModel;

  bool get visibleWeight => !creatorModel.isWeightUnit;

  Future<void> _doConversionEvent(
      DoConversionEvent event, Emitter<FoodCreatorState> emit) async {
    final int? index = event.index;
    final FoodRecord? foodRecord = event.foodRecord;
    if (foodRecord == null) {
      return;
    }

    // Result<Uint8List?> imageResult = await _fetchUserFoodImageUseCase.call(FetchUserFoodImageParams(id: foodRecord.iconId));
    // Uint8List? image;
    // switch(imageResult) {
    //   case Success<Uint8List?>():
    //     image = imageResult.value;
    //     break;
    //   case Error<Uint8List?>():
    //     break;
    // }
    _creatorModel = FoodCreatorModel.fromFoodRecord(foodRecord);
    emit(InitialState(foodCreatorModel: _creatorModel));
  }

  void _handleUpdateImageEvent(
      UpdateImageEvent event, Emitter<FoodCreatorState> emit) {
    final Uint8List? image = event.image;
    if (image == null) {
      return;
    }
    _creatorModel.setImage(image);
  }

  void _handleUpdateNameEvent(
      UpdateNameEvent event, Emitter<FoodCreatorState> emit) {
    _creatorModel.setName(event.name);
  }

  void _handleUpdateBrandEvent(
      UpdateBrandEvent event, Emitter<FoodCreatorState> emit) {
    _creatorModel.setBrand(event.brand);
  }

  void _handleUpdateServingSizeEvent(
      UpdateServingSizeEvent event, Emitter<FoodCreatorState> emit) {
    final servingSize = event.servingSize;
    try {
      final size = double.parse(servingSize);
      _creatorModel.setServingSize(size);
    } catch (e) {
      return;
    }
  }

  void _handleUpdateUnitEvent(
      UpdateUnitEvent event, Emitter<FoodCreatorState> emit) {
    final unit = event.unit;
    if (unit == null) {
      return;
    }
    _creatorModel.setUnit(unit);
    emit(UnitChangedState(unit: unit));
  }

  void _handleUpdateWeightEvent(
      UpdateWeightEvent event, Emitter<FoodCreatorState> emit) {
    final weight = event.weight;
    try {
      final w = double.parse(weight);
      _creatorModel.setWeight(w);
    } catch (e) {
      return;
    }
  }

  void _handleUpdateWeightSymbolEvent(
      UpdateWeightSymbolEvent event, Emitter<FoodCreatorState> emit) {
    final weightSymbol = event.weightSymbol;
    if (weightSymbol == null) {
      return;
    }
    _creatorModel.setWeightSymbol(weightSymbol);
    emit(WeightSymbolChangedState(weightSymbol: weightSymbol));
  }

  void _handleUpdateCaloriesEvent(
      UpdateCaloriesEvent event, Emitter<FoodCreatorState> emit) {
    final calories = event.calories;
    try {
      final cal = double.parse(calories);
      _creatorModel.setCalories(cal);
    } catch (e) {
      return;
    }
  }

  void _handleUpdateCarbsEvent(
      UpdateCarbsEvent event, Emitter<FoodCreatorState> emit) {
    final carbs = event.carbs;
    try {
      final carb = double.parse(carbs);
      _creatorModel.setCarbs(carb);
    } catch (e) {
      return;
    }
  }

  void _handleUpdateFatEvent(
      UpdateFatEvent event, Emitter<FoodCreatorState> emit) {
    final fat = event.fat;
    try {
      final f = double.parse(fat);
      _creatorModel.setFat(f);
    } catch (e) {
      return;
    }
  }

  void _handleUpdateProteinEvent(
      UpdateProteinEvent event, Emitter<FoodCreatorState> emit) {
    final protein = event.protein;
    try {
      final p = double.parse(protein);
      _creatorModel.setProtein(p);
    } catch (e) {
      return;
    }
  }

  void _handleSelectOtherNutritionFactsEvent(
      SelectOtherNutritionFactsEvent event, Emitter<FoodCreatorState> emit) {
    final selectedNutrient = event.selectedNutrient;
    _creatorModel.selectOtherNutritionFact(selectedNutrient);
    emit(OtherNutritionFactsSelectedState(selectedNutrient: selectedNutrient));
  }

  void _handleUpdateOtherNutritionFactsEvent(
      UpdateOtherNutritionFactsEvent event, Emitter<FoodCreatorState> emit) {
    final selectedNutrient = event.selectedNutrient;
    _creatorModel.updateOtherNutritionFact(selectedNutrient);
    emit(OtherNutritionFactsSelectedState(selectedNutrient: selectedNutrient));
  }

  void _handleRemoveOtherNutritionFactsEvent(
      RemoveOtherNutritionFactsEvent event, Emitter<FoodCreatorState> emit) {
    final selectedNutrient = event.selectedNutrient;
    _creatorModel.removeOtherNutritionFact(selectedNutrient);
    emit(OtherNutritionFactsRemovedState(selectedNutrient: selectedNutrient));
  }

  void _handleSubmitUserCreatedFoodEvent(
      SubmitUserCreatedFoodEvent event, Emitter<FoodCreatorState> emit) async {
    try {
      emit(const SaveLoadingState());
      await _saveCommand.execute();
    } finally {
      _saveCommand.clearResult();
    }
  }

  Future<Result<void>> _saveFood() async {
    final FoodRecord? foodRecord = _creatorModel.toFoodRecord();
    if (foodRecord == null) {
      final Result<void> result =
          Result.error(Exception('Invalid food record'));
      if (result is Error) {
        add(SaveErrorEvent(message: result.error.toString()));
      }
      return result;
    }

    final bool isNew = foodRecord.id.isEmpty;

    final List<Future<Result<void>>> queue = [];
    final image = _creatorModel.getImage();
    if (_creatorModel.isImageUpdate() && image != null) {
      queue.add(_updateUserFoodImageUseCase.call(UpdateUserFoodImageParams(
          id: foodRecord.iconId, image: image, isNew: isNew)));
    }
    queue.add(_updateUserFoodUseCase
        .call(UpdateUserFoodParams(foodRecord: foodRecord, isNew: isNew)));

    final List<Result<void>> result = await Future.wait(queue);
    for (final Result<void> r in result) {
      if (r is Error) {
        add(SaveErrorEvent(message: r.error.toString()));
        return r;
      }
    }
    add(const SaveSuccessEvent());
    return result.first;
  }

  void _handleSaveSuccessEvent(
      SaveSuccessEvent event, Emitter<FoodCreatorState> emit) {
    emit(const SaveSuccessState());
  }

  void _handleSaveErrorEvent(
      SaveErrorEvent event, Emitter<FoodCreatorState> emit) {
    emit(SaveErrorState(message: event.message));
  }

  void _handleUpdateBarcodeEvent(
      UpdateBarcodeEvent event, Emitter<FoodCreatorState> emit) {
    final barcode = event.barcode;
    _creatorModel.setBarcode(barcode);
    add(const UpdateFoodDetailsEvent());
  }

  void _handleUpdateFoodDetailsEvent(
      UpdateFoodDetailsEvent event, Emitter<FoodCreatorState> emit) {
    emit(UpdateFoodDetailsState(
        name: _creatorModel.getName(),
        brand: _creatorModel.getBrand(),
        barcode: _creatorModel.getBarcode()));
  }
}
