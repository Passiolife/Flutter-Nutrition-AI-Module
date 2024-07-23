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

final class UpdateSaveListenerState extends ListenerState {
  const UpdateSaveListenerState({required this.saveEnabled});

  final bool saveEnabled;

  @override
  List<Object?> get props => [saveEnabled];
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

final class UpdateSaveBuilderState extends BuilderState {
  const UpdateSaveBuilderState();

  @override
  List<Object?> get props => [];
}
