import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/settings/settings.dart';
import '../widgets/bottom_navigation_widget.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  bool tokenTrackingEnabled = false;

  DashboardBloc() : super(const DashboardInitial()) {
    on<PageUpdateEvent>(_handlePageUpdateEvent);
    on<RefreshEvent>(_handleRefreshEvent);
    on<RequestTokenTrackingEvent>(_handleGetTokenTrackingEvent);
  }

  FutureOr<void> _handlePageUpdateEvent(
      PageUpdateEvent event, Emitter<DashboardState> emit) {
    emit(PageUpdateState(index: event.index));
  }

  Future<void> _handleRefreshEvent(
      RefreshEvent event, Emitter<DashboardState> emit) async {
    emit(RefreshState(dateTime: DateTime.now().millisecondsSinceEpoch));
  }

  FutureOr<void> _handleGetTokenTrackingEvent(RequestTokenTrackingEvent event, Emitter<DashboardState> emit) async {
    final settings = Settings.instance;
    bool tokenTrackingEnabled = settings.getTokenTracking();
    emit(TokenTrackingUpdateState(enabled: tokenTrackingEnabled));
  }
}
