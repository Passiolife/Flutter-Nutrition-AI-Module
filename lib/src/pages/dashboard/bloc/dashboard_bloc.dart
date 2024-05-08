import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bottom_navigation_widget.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<PageUpdateEvent>(_handlePageUpdateEvent);
    on<RefreshEvent>(_handleRefreshEvent);
  }

  FutureOr<void> _handlePageUpdateEvent(
      PageUpdateEvent event, Emitter<DashboardState> emit) {
    emit(PageUpdateState(index: event.index, item: event.item));
  }

  Future<void> _handleRefreshEvent(
      RefreshEvent event, Emitter<DashboardState> emit) async {
    emit(RefreshState(dateTime: DateTime.now().millisecondsSinceEpoch));
  }
}
