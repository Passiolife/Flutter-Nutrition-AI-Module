part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class PageUpdateEvent extends DashboardEvent {
  final int index;

  const PageUpdateEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

final class RefreshEvent extends DashboardEvent {
  const RefreshEvent();

  @override
  List<Object?> get props => [];
}
