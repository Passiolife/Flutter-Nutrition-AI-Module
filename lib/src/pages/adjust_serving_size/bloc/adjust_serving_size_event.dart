part of 'adjust_serving_size_bloc.dart';

sealed class AdjustServingSizeEvent extends Equatable {
  const AdjustServingSizeEvent();
}

final class ProcessEvent extends AdjustServingSizeEvent {
  final FoodRecord? foodRecord;
  final int? index;
  final Uint8List? image;

  const ProcessEvent({
    this.foodRecord,
    this.index,
    this.image,
  });

  @override
  List<Object?> get props => [foodRecord, index, image];
}

final class RefreshDetailsEvent extends AdjustServingSizeEvent {
  const RefreshDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateServingSizeEvent extends AdjustServingSizeEvent {
  final double quantity;
  final String unit;

  const UpdateServingSizeEvent({
    required this.quantity,
    required this.unit,
  });

  @override
  List<Object?> get props => [quantity, unit];
}

final class RefreshServingSizeEvent extends AdjustServingSizeEvent {
  const RefreshServingSizeEvent();

  @override
  List<Object?> get props => [];
}