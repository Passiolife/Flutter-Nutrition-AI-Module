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
  const UpdateMacroNutrientState({required this.viewModel});

  final TakePhotoResultViewModel viewModel;

  @override
  List<Object?> get props => [viewModel];
}

final class UpdateActionButtonsState extends TakePhotoResultState {
  const UpdateActionButtonsState({required this.viewModel});

  final TakePhotoResultViewModel viewModel;

  @override
  List<Object> get props => [viewModel];
}
