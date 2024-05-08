part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class PageUpdateEvent extends DashboardEvent {
  final int index;
  final NavigationItem? item;

  const PageUpdateEvent({required this.index, this.item});

  @override
  List<Object?> get props => [index, item];
}

final class RefreshEvent extends DashboardEvent {
  const RefreshEvent();

  @override
  List<Object?> get props => [];
}
