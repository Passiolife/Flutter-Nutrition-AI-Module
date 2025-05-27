part of 'add_water_bloc.dart';

sealed class AddWaterState  extends Equatable {
  const AddWaterState();
}

final class InitialState extends AddWaterState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class UpdateWaterState extends AddWaterState {
  const UpdateWaterState({required this.water});
  final String water;

  @override
  List<Object?> get props => [water];
}

final class UpdateUnitSymbolState extends AddWaterState {
  const UpdateUnitSymbolState({required this.unitSymbol});
  final String unitSymbol;

  @override
  List<Object?> get props => [unitSymbol];
}

final class UpdateDayState extends AddWaterState {
  const UpdateDayState({required this.dateTime});
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class UpdateTimeState extends AddWaterState {
  const UpdateTimeState({required this.dateTime});
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class UpdateActionButtonState extends AddWaterState {
  const UpdateActionButtonState({required this.isNew});
  final bool isNew;

  @override
  List<Object?> get props => [isNew];
}

final class SaveSuccessState extends AddWaterState {
  const SaveSuccessState();

  @override
  List<Object?> get props => [];
}

final class SaveFailureState extends AddWaterState {
  const SaveFailureState({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}