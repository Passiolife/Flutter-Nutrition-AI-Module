part of 'advisor_bloc.dart';

sealed class AdvisorEvent extends Equatable {
  const AdvisorEvent();
}

final class DoInitializationEvent extends AdvisorEvent {
  const DoInitializationEvent();

  @override
  List<Object?> get props => [];
}

final class DoSendMessageEvent extends AdvisorEvent {
  const DoSendMessageEvent({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

final class DoFetchIngredientsEvent extends AdvisorEvent {
  const DoFetchIngredientsEvent({
    required this.index,
    this.advisorChat,
  });

  final int index;
  final AdvisorChat? advisorChat;

  @override
  List<Object?> get props => [index, advisorChat];
}

final class DoChangeSelectionEvent extends AdvisorEvent {
  const DoChangeSelectionEvent({
    required this.index,
    required this.itemIndex,
    required this.advisorFoodInfoLog,
    this.advisorChat,
  });

  final int index;
  final int itemIndex;
  final AdvisorChat? advisorChat;
  final AdvisorFoodInfoLog advisorFoodInfoLog;

  @override
  List<Object?> get props =>
      [index, itemIndex, advisorChat, advisorFoodInfoLog];
}

final class DoSendImageEvent extends AdvisorEvent {
  const DoSendImageEvent({this.images});

  final List<dynamic>? images;

  @override
  List<Object?> get props => [images];
}

final class DoFoodLogEvent extends AdvisorEvent {
  final int index;
  final AdvisorChat? data;

  const DoFoodLogEvent({
    required this.index,
    required this.data,
  });

  @override
  List<Object?> get props => [index, data];
}
