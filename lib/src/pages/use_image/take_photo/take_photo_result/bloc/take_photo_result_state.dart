part of 'take_photo_result_bloc.dart';

sealed class TakePhotoResultState extends Equatable {
  const TakePhotoResultState();
}

final class TakePhotoResultInitial extends TakePhotoResultState {
  const TakePhotoResultInitial();

  @override
  List<Object> get props => [];
}

final class FinishGeneratingResultsState extends TakePhotoResultState {
  const FinishGeneratingResultsState();

  @override
  List<Object> get props => [];
}

final class ResultFailureState extends TakePhotoResultState {
  const ResultFailureState();

  @override
  List<Object?> get props => [];
}

final class ResultsSuccessState extends TakePhotoResultState {
  const ResultsSuccessState({required this.foodRecordsViewModel});

  final List<FoodRecordViewModel> foodRecordsViewModel;

  @override
  List<Object> get props => [foodRecordsViewModel];
}

final class UpdateHeaderState extends TakePhotoResultState {
  const UpdateHeaderState({required this.viewModel});

  final TakePhotoResultViewModel viewModel;

  @override
  List<Object> get props => [viewModel];
}

final class UpdateMacroNutrientState extends TakePhotoResultState {
  const UpdateMacroNutrientState({required this.listMacros});

  final List<DailyNutritionModel> listMacros;

  @override
  List<Object?> get props => [listMacros];
}

final class UpdateActionButtonsState extends TakePhotoResultState {
  const UpdateActionButtonsState(
      {required this.viewModel, required this.timestamp});

  final int timestamp;
  final TakePhotoResultViewModel viewModel;

  @override
  List<Object> get props => [timestamp];
}

final class CreateRecipeSuccessState extends TakePhotoResultState {
  const CreateRecipeSuccessState(
      {required this.timestamp, required this.foodRecord});

  final int timestamp;
  final FoodRecord foodRecord;

  @override
  List<Object> get props => [timestamp, foodRecord];
}

final class FoodLogSuccessState extends TakePhotoResultState {
  const FoodLogSuccessState();

  @override
  List<Object> get props => [];
}
