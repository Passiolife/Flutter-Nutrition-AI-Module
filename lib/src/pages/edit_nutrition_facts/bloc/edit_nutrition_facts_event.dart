part of 'edit_nutrition_facts_bloc.dart';

sealed class EditNutritionFactsEvent extends Equatable {
  const EditNutritionFactsEvent();
}

final class ProcessEvent extends EditNutritionFactsEvent {
  const ProcessEvent({
    this.foodRecord,
    this.barcodeFoodRecord,
    this.imageBytes,
    this.barcode,
  });

  final FoodRecord? foodRecord;
  final FoodRecord? barcodeFoodRecord;
  final Uint8List? imageBytes;
  final String? barcode;

  @override
  List<Object?> get props => [foodRecord, barcodeFoodRecord, imageBytes, barcode];
}

final class RefreshDetailsEvent extends EditNutritionFactsEvent {
  const RefreshDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateNutritionFactsEvent extends EditNutritionFactsEvent {
  const UpdateNutritionFactsEvent({
    this.calories,
    this.carbs,
    this.protein,
    this.fat,
  });

  final double? calories;
  final double? carbs;
  final double? protein;
  final double? fat;

  @override
  List<Object?> get props => [
        calories,
        carbs,
        protein,
        fat,
      ];
}

final class RefreshNutritionFactsEvent extends EditNutritionFactsEvent {
  const RefreshNutritionFactsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdatePortionsEvent extends EditNutritionFactsEvent {
  const UpdatePortionsEvent({this.quantity, this.weight, this.unit});

  final double? quantity;
  final double? weight;
  final String? unit;

  @override
  List<Object?> get props => [quantity, weight, unit];
}

final class RefreshPortionsEvent extends EditNutritionFactsEvent {
  const RefreshPortionsEvent();

  @override
  List<Object?> get props => [];
}

final class RefreshActionButtonsEvent extends EditNutritionFactsEvent {
  const RefreshActionButtonsEvent();

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

final class PopulateBarcodeScannerDataEvent extends EditNutritionFactsEvent {
  const PopulateBarcodeScannerDataEvent({required this.data});
  final dynamic data;

  @override
  List<Object?> get props => [data];
}