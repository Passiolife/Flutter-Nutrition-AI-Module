part of 'edit_nutrition_facts_bloc.dart';

sealed class EditNutritionFactsEvent extends Equatable {
  const EditNutritionFactsEvent();
}

final class ProcessEvent extends EditNutritionFactsEvent {
  const ProcessEvent({
    this.foodRecord,
    this.imageBytes,
    this.barcode,
  });

  final FoodRecord? foodRecord;
  final Uint8List? imageBytes;
  final String? barcode;

  @override
  List<Object?> get props => [foodRecord, imageBytes, barcode];
}

final class UpdateDetailsEvent extends EditNutritionFactsEvent {
  const UpdateDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateNutritionFactsEvent extends EditNutritionFactsEvent {
  const UpdateNutritionFactsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdatePortionsEvent extends EditNutritionFactsEvent {
  const UpdatePortionsEvent();

  @override
  List<Object?> get props => [];

}

final class UpdateNameEvent extends EditNutritionFactsEvent {
  final String name;

  const UpdateNameEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

final class UpdateBarcodeEvent extends EditNutritionFactsEvent {
  final String barcode;

  const UpdateBarcodeEvent({required this.barcode});

  @override
  List<Object?> get props => [barcode];
}

final class SaveEvent extends EditNutritionFactsEvent {
  const SaveEvent();

  @override
  List<Object?> get props => [];
}
