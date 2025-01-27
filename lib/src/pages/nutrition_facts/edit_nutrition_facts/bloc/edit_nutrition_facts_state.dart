part of 'edit_nutrition_facts_bloc.dart';

sealed class EditNutritionFactsState extends Equatable {
  const EditNutritionFactsState();
}

final class EditNutritionFactsInitial extends EditNutritionFactsState {
  const EditNutritionFactsInitial();

  @override
  List<Object> get props => [];
}

final class RefreshDetailsState extends EditNutritionFactsState {
  const RefreshDetailsState({
    this.iconId,
    this.barcode,
    this.name,
    this.imageBytes,
  });

  final String? iconId;
  final String? barcode;
  final String? name;
  final Uint8List? imageBytes;

  @override
  List<Object?> get props => [iconId, barcode, name, imageBytes];
}

final class RefreshNutritionFactsState extends EditNutritionFactsState {
  const RefreshNutritionFactsState({
    this.calories,
    this.carbs,
    this.protein,
    this.fat,
  });

  final String? calories;
  final String? carbs;
  final String? protein;
  final String? fat;

  @override
  List<Object?> get props => [calories, carbs, protein, fat];
}

final class RefreshPortionsState extends EditNutritionFactsState {
  const RefreshPortionsState({
    this.selectedQuantity,
    this.selectedUnit,
    this.units,
    this.weight,
  });

  final String? selectedQuantity;
  final String? selectedUnit;
  final List<String>? units;
  final String? weight;

  @override
  List<Object?> get props => [selectedQuantity, selectedUnit, units, weight];
}

final class RefreshActionButtonsState extends EditNutritionFactsState {
  const RefreshActionButtonsState({
    required this.isUpdate,
  });

  final bool isUpdate;

  @override
  List<Object?> get props => [];
}

final class SaveSuccessState extends EditNutritionFactsState {
  const SaveSuccessState();

  @override
  List<Object> get props => [];
}
