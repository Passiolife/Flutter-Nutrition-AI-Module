part of 'water_bloc.dart';

sealed class WaterState extends Equatable {
  const WaterState();
}

final class InitialState extends WaterState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class UpdateTabState extends WaterState {
  const UpdateTabState({required this.tab});

  final int tab;

  @override
  List<Object?> get props => [tab];
}

final class UpdatePageState extends WaterState {
  const UpdatePageState({required this.page});

  final int page;

  @override
  List<Object?> get props => [page];
}

final class UpdateQuickAddState extends WaterState {
  const UpdateQuickAddState({
    required this.glassValue,
    required this.smallBottleValue,
    required this.largeBottleValue,
    required this.unitSymbol,
  });

  final double glassValue;
  final double smallBottleValue;
  final double largeBottleValue;
  final String unitSymbol;

  @override
  List<Object?> get props =>
      [glassValue, smallBottleValue, largeBottleValue, unitSymbol];
}

final class UpdateRecordsState extends WaterState {
  const UpdateRecordsState({
    required this.unitSymbol,
    required this.unit,
    required this.records,
    required this.startDate,
    required this.endDate,
    required this.isMonthRange,
    // required this.time,
  });

  final MeasurementSystem unit;
  final String unitSymbol;
  final List<WaterRecord> records;
  final DateTime startDate;
  final DateTime endDate;
  final bool isMonthRange;
  // final int time;

  @override
  List<Object?> get props => [
        records,
        unitSymbol,
        startDate,
        endDate,
        isMonthRange,
        // time,
      ];
}

final class FetchRecordsSuccessState extends WaterState {
  const FetchRecordsSuccessState({required this.records});

  final List<WaterRecord> records;

  @override
  List<Object?> get props => [records];
}

final class FetchRecordsFailureState extends WaterState {
  const FetchRecordsFailureState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class QuickAddSuccessState extends WaterState {
  const QuickAddSuccessState();

  @override
  List<Object?> get props => [];
}

final class QuickAddFailureState extends WaterState {
  const QuickAddFailureState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class UpdateWaterTrendState extends WaterState {
  const UpdateWaterTrendState({
    required this.chartData,
    required this.maximumValue,
    required this.targetValue,
  });

  final List<WaterChartData> chartData;
  final double maximumValue;
  final double targetValue;

  @override
  List<Object?> get props => [];
}

final class DeleteWaterFailureState extends WaterState {
  const DeleteWaterFailureState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
