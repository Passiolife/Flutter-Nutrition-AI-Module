part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();

  @override
  List<Object> get props => [];
}

final class PageUpdateState extends DashboardState {
  final int index;
  final NavigationItem? item;

  const PageUpdateState({required this.index, this.item});

  @override
  List<Object?> get props => [index, item];
}

final class RefreshState extends DashboardState {
  const RefreshState({required this.dateTime});
  final int dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class TokenTrackingUpdateState extends DashboardState {
  const TokenTrackingUpdateState({required this.enabled});
  final bool enabled;

  @override
  List<Object?> get props => [enabled];

}