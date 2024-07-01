part of 'advisor_bloc.dart';

sealed class AdvisorState extends Equatable {
  const AdvisorState();
}

final class AdvisorInitial extends AdvisorState {
  const AdvisorInitial();

  @override
  List<Object> get props => [];
}

// Listeners
sealed class ListenerState extends AdvisorState {
  const ListenerState();
}

final class ConfigureErrorListenerState extends ListenerState {
  const ConfigureErrorListenerState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class InitializationSuccessListenerState extends ListenerState {
  const InitializationSuccessListenerState({required this.chats});

  final List<AdvisorChat> chats;

  @override
  List<Object?> get props => [chats];
}

final class InitializationErrorListenerState extends ListenerState {
  const InitializationErrorListenerState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class SendLoadingListenerState extends ListenerState {
  const SendLoadingListenerState({required this.chats});

  final List<AdvisorChat> chats;

  @override
  List<Object?> get props => [chats];
}

final class SendSuccessListenerState extends ListenerState {
  const SendSuccessListenerState({required this.chats});

  final List<AdvisorChat> chats;

  @override
  List<Object?> get props => [chats];
}

final class ChangeSelectionListenerState extends ListenerState {
  const ChangeSelectionListenerState({required this.chats});

  final List<AdvisorChat> chats;

  @override
  List<Object?> get props => [chats];
}

final class FoodLogLoadingListenerState extends ListenerState {
  const FoodLogLoadingListenerState({required this.chats});

  final List<AdvisorChat> chats;

  @override
  List<Object?> get props => [chats];
}

final class FoodLogSuccessListenerState extends ListenerState {
  const FoodLogSuccessListenerState({required this.chats});

  final List<AdvisorChat> chats;

  @override
  List<Object?> get props => [chats];
}

// Builders
sealed class BuilderState extends AdvisorState {
  const BuilderState();
}

final class ConfigureErrorBuilderState extends BuilderState {
  const ConfigureErrorBuilderState();

  @override
  List<Object?> get props => [];
}

final class InitializationErrorBuilderState extends BuilderState {
  const InitializationErrorBuilderState();

  @override
  List<Object?> get props => [];
}

final class SendLoadingBuilderState extends BuilderState {
  const SendLoadingBuilderState();

  @override
  List<Object?> get props => [];
}

final class InitializationSuccessBuilderState extends BuilderState {
  const InitializationSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class SendSuccessBuilderState extends BuilderState {
  const SendSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class ChangeSelectionBuilderState extends BuilderState {
  const ChangeSelectionBuilderState();

  @override
  List<Object?> get props => [];
}

final class FoodLogLoadingBuilderState extends BuilderState {
  const FoodLogLoadingBuilderState();

  @override
  List<Object?> get props => [];
}

final class FoodLogSuccessBuilderState extends BuilderState {
  const FoodLogSuccessBuilderState();

  @override
  List<Object?> get props => [];
}
