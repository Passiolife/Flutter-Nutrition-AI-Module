part of 'token_usage_bloc.dart';

sealed class TokenUsageEvent extends Equatable {
  const TokenUsageEvent();
}

final class StartListeningEvent extends TokenUsageEvent {
  const StartListeningEvent();

  @override
  List<Object?> get props => [];
}

final class StopListeningEvent extends TokenUsageEvent {
  const StopListeningEvent();

  @override
  List<Object?> get props => [];
}

final class TokenBudgetUpdateEvent extends TokenUsageEvent {
  const TokenBudgetUpdateEvent(this.tokenBudget);
  final PassioTokenBudget tokenBudget;

  @override
  List<Object?> get props => [tokenBudget];
}

final class GetLastUpdatedEvent extends TokenUsageEvent {
  const GetLastUpdatedEvent();

  @override
  List<Object?> get props => [];
}