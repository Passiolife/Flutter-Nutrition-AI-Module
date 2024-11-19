part of 'food_creator_bloc.dart';

sealed class FoodCreatorState extends Equatable {
  const FoodCreatorState();
}

final class FoodCreatorInitial extends FoodCreatorState {
  @override
  List<Object> get props => [];
}

// Listeners
sealed class ListenerState extends FoodCreatorState {
  const ListenerState();
}

final class ConversionSuccessListenerState extends ListenerState {
  const ConversionSuccessListenerState({
    required this.viewModel,
    required this.saveEnabled,
  });

  final FoodCreatorViewModel viewModel;
  final bool saveEnabled;

  @override
  List<Object?> get props => [viewModel, saveEnabled];
}

final class UpdateFoodDetailsSuccessListenerState extends ListenerState {
  const UpdateFoodDetailsSuccessListenerState(
      {required this.viewModel, required this.saveEnabled});

  final FoodCreatorViewModel viewModel;
  final bool saveEnabled;

  @override
  List<Object?> get props => [viewModel, saveEnabled];
}

final class UpdateBarcodeSuccessListenerState extends ListenerState {
  const UpdateBarcodeSuccessListenerState(
      {required this.viewModel, required this.saveEnabled});

  final FoodCreatorViewModel viewModel;
  final bool saveEnabled;

  @override
  List<Object?> get props => [viewModel, saveEnabled];
}

final class UpdateRequiredNutritionFactsSuccessListenerState
    extends ListenerState {
  const UpdateRequiredNutritionFactsSuccessListenerState(
      {required this.viewModel, required this.saveEnabled});

  final FoodCreatorViewModel viewModel;
  final bool saveEnabled;

  @override
  List<Object?> get props => [viewModel, saveEnabled];
}

final class UpdateOtherNutritionFactsSuccessListenerState
    extends ListenerState {
  const UpdateOtherNutritionFactsSuccessListenerState(
      {required this.viewModel, required this.saveEnabled});

  final FoodCreatorViewModel viewModel;
  final bool saveEnabled;

  @override
  List<Object?> get props => [viewModel, saveEnabled];
}

final class SaveSuccessState extends ListenerState {
  const SaveSuccessState();

  @override
  List<Object?> get props => [];
}

final class SaveFailureState extends ListenerState {
  const SaveFailureState({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

// Builders
sealed class BuilderState extends FoodCreatorState {
  const BuilderState();
}

final class ConversionSuccessBuilderState extends BuilderState {
  const ConversionSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class ConversionFailureBuilderState extends BuilderState {
  const ConversionFailureBuilderState();

  @override
  List<Object?> get props => [];
}

final class UpdateFoodDetailsSuccessBuilderState extends BuilderState {
  const UpdateFoodDetailsSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class UpdateBarcodeSuccessBuilderState extends BuilderState {
  const UpdateBarcodeSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class UpdateRequiredNutritionFactsSuccessBuilderState
    extends BuilderState {
  const UpdateRequiredNutritionFactsSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class UpdateOtherNutritionFactsSuccessBuilderState extends BuilderState {
  const UpdateOtherNutritionFactsSuccessBuilderState();

  @override
  List<Object?> get props => [];
}
