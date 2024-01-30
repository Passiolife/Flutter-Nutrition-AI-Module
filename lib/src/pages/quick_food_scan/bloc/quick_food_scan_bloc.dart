import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';

part 'quick_food_scan_event.dart';

part 'quick_food_scan_state.dart';

class QuickFoodScanBloc extends Bloc<QuickFoodScanEvent, QuickFoodScanState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  QuickFoodScanBloc() : super(QuickFoodScanInitial()) {
    on<RecognitionResultEvent>(_handleRecognitionResultEvent);
    on<ShowFoodDetailsViewEvent>(_handleShowFoodDetailsViewEvent);
    on<DoLogEvent>(_handleDoLogEvent);
    on<DoFavouriteEvent>(_handleDoFavouriteEvent);
  }

  Future _handleRecognitionResultEvent(
      RecognitionResultEvent event, Emitter<QuickFoodScanState> emit) async {
    /// [foodCandidates] from recognition result.
    final foodCandidates = event.foodCandidates;

    /// _displayed result
    final displayedResult = event.displayedResult;

    var passioID = foodCandidates.detectedCandidates.firstOrNull?.passioID;
    var barcode = foodCandidates.barcodeCandidates?.firstOrNull?.value;
    var packagedFoodCode =
        foodCandidates.packagedFoodCandidates?.firstOrNull?.packagedFoodCode;

    /// If the scan result is Bar code.
    if (barcode != null) {
      if (barcode != displayedResult) {
        final attributes =
            await NutritionAI.instance.fetchAttributesForBarcode(barcode);
        FoodRecord? foodRecord = FoodRecord.from(
            passioIDAttributes: attributes, dateTime: event.dateTime);
        emit(QuickFoodSuccessState(foodRecord: foodRecord, data: barcode));
      }
    }

    /// If the scan result is food package.
    else if (packagedFoodCode != null) {
      if (packagedFoodCode != displayedResult) {
        final attributes = await NutritionAI.instance
            .fetchAttributesForPackagedFoodCode(packagedFoodCode);
        FoodRecord? foodRecord = FoodRecord.from(
            passioIDAttributes: attributes, dateTime: event.dateTime);
        emit(QuickFoodSuccessState(
            foodRecord: foodRecord, data: packagedFoodCode));
      }
    }

    /// If the scan result is passioID.
    else if (passioID != null) {
      if (passioID != displayedResult) {
        final attributes =
            await NutritionAI.instance.lookupPassioAttributesFor(passioID);
        FoodRecord? foodRecord = FoodRecord.from(
            passioIDAttributes: attributes, dateTime: event.dateTime);
        emit(QuickFoodSuccessState(foodRecord: foodRecord, data: passioID));
      }
    }

    /// There is no any result then show searching UI.
    else {
      emit(QuickFoodLoadingState(isLoading: true));
    }
  }

  Future _handleShowFoodDetailsViewEvent(
      ShowFoodDetailsViewEvent event, Emitter<QuickFoodScanState> emit) async {
    emit(ShowFoodDetailsViewState(isVisible: event.isVisible));
  }

  FutureOr<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<QuickFoodScanState> emit) async {
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FoodInsertFailureState(
          message: 'Something went wrong while parsing data.'));
      return;
    }
    if (event.data != null) {
      await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
      emit(FoodInsertSuccessState());
    }
  }

  Future<void> _handleDoFavouriteEvent(
      DoFavouriteEvent event, Emitter<QuickFoodScanState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FavoriteFailureState(
            message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.updateFavorite(foodRecord: foodRecord, isNew: true);
      emit(FavoriteSuccessState());
    } catch (e) {
      emit(FavoriteFailureState(message: e.toString()));
    }
  }
}
