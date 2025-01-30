part of 'adjust_serving_size_bloc.dart';

sealed class AdjustServingSizeState extends Equatable {
  const AdjustServingSizeState();
}

final class AdjustServingSizeInitial extends AdjustServingSizeState {
  @override
  List<Object> get props => [];
}

final class RefreshDetailsState extends AdjustServingSizeState {
  final int? index;
  final Uint8List? image;
  final String iconId;
  final String title;
  final String subtitle;
  final bool isEditable;
  final int timestamp;

  const RefreshDetailsState({
    required this.index,
    required this.image,
    required this.iconId,
    required this.title,
    required this.subtitle,
    required this.isEditable,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [index, image, timestamp];
}

final class RefreshServingSizeState extends AdjustServingSizeState {
  final double quantity;
  final String unit;
  final List<String> units;
  final int timestamp;

  const RefreshServingSizeState({
    required this.quantity,
    required this.unit,
    required this.units,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [quantity, unit, units, timestamp];
}