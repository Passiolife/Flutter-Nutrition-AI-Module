import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'token_usage_event.dart';
part 'token_usage_state.dart';

class TokenUsageBloc extends Bloc<TokenUsageEvent, TokenUsageState>
    implements PassioAccountListener {

  int _session = 0;
  PassioTokenBudget? _tokenBudget;

  @override
  void onTokenBudgetUpdate(PassioTokenBudget tokenBudget) {
    log(tokenBudget.toString());
    add(TokenBudgetUpdateEvent(tokenBudget));
  }

  TokenUsageBloc() : super(const TokenUsageInitial()) {
    on<StartListeningEvent>(_handleStartListeningEvent);
    on<StopListeningEvent>(_handleStopListeningEvent);
    on<TokenBudgetUpdateEvent>(_handleTokenBudgetUpdateEvent);
    on<GetLastUpdatedEvent>(_handleGetLastUpdatedEvent);
  }

  FutureOr<void> _handleStartListeningEvent(
      StartListeningEvent event, Emitter<TokenUsageState> emit) {
    NutritionAI.instance.setAccountListener(this);
  }

  FutureOr<void> _handleStopListeningEvent(
      StopListeningEvent event, Emitter<TokenUsageState> emit) {
    NutritionAI.instance.setAccountListener(null);
  }

  FutureOr<void> _handleTokenBudgetUpdateEvent(
      TokenBudgetUpdateEvent event, Emitter<TokenUsageState> emit) {
    _tokenBudget = event.tokenBudget;
    _session += _tokenBudget?.tokensUsed ?? 0;
    emit(TokenBudgetUpdateListenerState(
        session: _session, tokenBudget: event.tokenBudget));
    emit(const TokenBudgetUpdateBuilderState());
  }

  FutureOr<void> _handleGetLastUpdatedEvent(GetLastUpdatedEvent event, Emitter<TokenUsageState> emit) {
    emit(TokenBudgetUpdateListenerState(
        session: _session, tokenBudget: _tokenBudget));
    emit(const TokenBudgetUpdateBuilderState());
  }
}
