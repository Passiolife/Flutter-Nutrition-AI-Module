part of 'token_usage_bloc.dart';

sealed class TokenUsageState extends Equatable {
  const TokenUsageState();
}

final class TokenUsageInitial extends TokenUsageState {
  const TokenUsageInitial();

  @override
  List<Object> get props => [];
}

sealed class ListenerState extends TokenUsageState {
  const ListenerState();
}

final class TokenBudgetUpdateListenerState extends ListenerState {
  const TokenBudgetUpdateListenerState({
    required this.session,
    this.tokenBudget,
  });

  final int session;
  final PassioTokenBudget? tokenBudget;

  @override
  List<Object?> get props => [session, tokenBudget];
}

sealed class BuilderState extends TokenUsageState {
  const BuilderState();
}

final class TokenBudgetUpdateBuilderState extends BuilderState {
  const TokenBudgetUpdateBuilderState();

  @override
  List<Object?> get props => [];
}
