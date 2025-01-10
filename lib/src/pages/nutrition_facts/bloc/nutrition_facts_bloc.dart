import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../common/domain/repository/nutrition_ai_repository.dart';
import '../../../common/extension/passio/passio_food_item_extension.dart';
import '../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';
import '../../../common/models/settings/settings.dart';
import '../../../common/util/flutter_image_compress_util.dart';

part 'nutrition_facts_event.dart';
part 'nutrition_facts_state.dart';

class NutritionFactsBloc extends Bloc<TakePhotoEvent, NutritionFactsState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  Uint8List? _images;
  Uint8List? _resizedImages;

  final NutritionAIRepository nutritionAIRepository;

  PassioFoodItem? _nutritionFacts;
  PassioFoodItem? _ingredients;
  PassioFoodItem? _finalFoodItem;

  int _section = 0;

  NutritionFactsBloc({required this.nutritionAIRepository}) : super(const InitialBuilderState()) {
    on<DoCheckIntroScreenEvent>(_handleDoCheckIntroScreenEvent);
    on<ShowIntroScreenEvent>(_handleShowIntroScreenEvent);
    on<DoIntroScreenCompletedEvent>(_handleDoIntroScreenCompletedEvent);
    // on<InitialEvent>(_handleInitialEvent);
    on<DoTakeImageEvent>(_handleDoTakeImageEvent);
    on<DoRecognizeImageEvent>(_handleDoRecognizeImageEvent);
    on<UpdateSectionEvent>(_handleUpdateSectionEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
  }

  FutureOr<void> _handleDoCheckIntroScreenEvent(
      DoCheckIntroScreenEvent event, Emitter<NutritionFactsState> emit) {
    final seen = Settings.instance.getNutritionFactsIntroSeen();
    if (seen) {
      add(const DoIntroScreenCompletedEvent());
    } else {
      emit(ShowIntroDialogListenerState(DateTime.now().millisecond));
    }
  }

  FutureOr<void> _handleShowIntroScreenEvent(
      ShowIntroScreenEvent event, Emitter<NutritionFactsState> emit) {
    emit(ShowIntroDialogListenerState(DateTime.now().millisecond));
  }

  FutureOr<void> _handleDoIntroScreenCompletedEvent(
      DoIntroScreenCompletedEvent event, Emitter<NutritionFactsState> emit) {
    if (event.fromDialog) {
      Settings.instance.setNutritionFactsIntroSeen(true);
    }
    emit(const IntroDialogSeenBuilderState());
  }

  FutureOr<void> _handleDoTakeImageEvent(
      DoTakeImageEvent event, Emitter<NutritionFactsState> emit) async {
    final file = event.file;
    if (file != null) {
      Uint8List? image = await FlutterImageCompressUtil.angleCorrect(file.path);
      if (image == null) {
        return;
      }
      _section = 1;
      emit(UpdateSectionBuilderState(section: _section));
      add(DoRecognizeImageEvent(image: image));
    }
    /*if (event.file != null) {
      final bytes =
          await FlutterImageCompressUtil.angleCorrect(event.file!.path);
      final resizedBytes = await FlutterImageCompressUtil.compress(
        event.file!.path,
        minWidth: 200,
        minHeight: 200,
      );
      if (bytes != null && resizedBytes != null) {
        _images = List.from(_images)..insert(0, bytes);

        // _resizedImages = List.from(_resizedImages)..insert(0, resizedBytes);
      }
    }*/
  }

  FutureOr<void> _handleDoRecognizeImageEvent(
      DoRecognizeImageEvent event, Emitter<NutritionFactsState> emit) async {
    final image = event.image;
    emit(PreviewBuilderState(image: image, analyzedCompleted: false));
    final foodItem = await nutritionAIRepository.recognizeNutritionFacts(image);
    emit(PreviewBuilderState(image: image, analyzedCompleted: true));
    await Future.delayed(Duration(milliseconds: 500));

    if(_section == 0) {
      return;
    }

    if (foodItem == null) {
      emit(FailedToAnalyzedState(timestamp: DateTime.now().millisecond));
      return;
    } else if(foodItem.hasMacros) {
      if(foodItem.hasIngredientsDescription) {
        _finalFoodItem = foodItem;
        return;
      }
      _nutritionFacts = foodItem;

    } else if(foodItem.hasIngredientsDescription) {
      _ingredients = foodItem;
    }
    if (_nutritionFacts == null && _ingredients == null) {
      emit(BothNotFoundState(timestamp: DateTime.now().millisecond));
    } else if (_nutritionFacts == null) {
      emit(NutritionFactsNotFoundState(timestamp: DateTime.now().millisecond));
    } else if (_ingredients == null) {
      emit(IngredientsNotFoundState(timestamp: DateTime.now().millisecond));
    }
  }

  void _handleUpdateSectionEvent(UpdateSectionEvent event, Emitter<NutritionFactsState> emit) {
    _section = event.section;
    emit(UpdateSectionBuilderState(section: _section));
  }

  void _handleFoodItemAnalysis(PassioFoodItem foodItem, Emitter<NutritionFactsState> emit) {
    // if (foodItem.hasMacros) {
    //   _nutritionFacts = foodItem;
    //   if (foodItem.hasIngredientsDescription) {
    //     _finalFoodItem = foodItem;
    //     emit(FullAnalysisCompleteState(timestamp: DateTime.now()));
    //     return;
    //   }
    // } else if (foodItem.hasIngredientsDescription) {
    //   _ingredients = foodItem;
    // }

    _emitAppropriateState(emit);
  }

  void _emitAppropriateState(Emitter<NutritionFactsState> emit) {
    // if (_nutritionFacts == null && _ingredients == null) {
    //   emit(NoDataFoundState(timestamp: DateTime.now()));
    // } else if (_nutritionFacts == null) {
    //   emit(MissingNutritionFactsState(timestamp: DateTime.now()));
    // } else if (_ingredients == null) {
    //   emit(MissingIngredientsState(timestamp: DateTime.now()));
    // }
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<NutritionFactsState> emit) async {
    // emit(const FoodLogLoadingListenerState());
    emit(const FoodLogLoadingBuilderState());

    final selectedLogs = event.data?.where((e) => e.isSelected).toList();

    if (selectedLogs == null || selectedLogs.isEmpty) {
      // emit(const FoodLogSuccessListenerState());
      return;
    }

    try {
      List<FoodRecord?> foodRecords =
          await Future.wait(selectedLogs.map((element) async {
        final advisorFoodInfo = element.advisorFoodInfoModel;
        final foodDataInfo = advisorFoodInfo?.foodDataInfo;
        if (foodDataInfo == null) return null;

        try {
          final nutritionPreview = foodDataInfo.nutritionPreview;
          final foodItem = await NutritionAI.instance.fetchFoodItemForDataInfo(
            foodDataInfo,
            servingQuantity: nutritionPreview.servingQuantity,
            servingUnit: nutritionPreview.servingUnit,
          );
          if (foodItem == null) return null;

          final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);

          return foodRecord;
        } catch (e) {
          return null;
        }
      }).toList());

      // Remove any null values resulting from failed fetch operations
      foodRecords = foodRecords.where((record) => record != null).toList();

      // Update records concurrently using Future.wait
      await Future.wait(foodRecords.map((foodRecord) async {
        try {
          await _connector.updateRecord(foodRecord: foodRecord!, isNew: true);
        } catch (e) {
          // emit(const FoodLogFailureListenerState());
        }
      }));

      // emit(const FoodLogSuccessListenerState());
    } catch (e) {
      // emit(const FoodLogFailureListenerState());
    }
  }
}
