part of 'edit_nutrition_facts_bloc.dart';

sealed class EditNutritionFactsState extends Equatable {
  const EditNutritionFactsState();
}

final class EditNutritionFactsInitial extends EditNutritionFactsState {
  @override
  List<Object> get props => [];
}

final class UpdateDetailsState extends EditNutritionFactsState {
  const UpdateDetailsState({
    required this.iconId,
    required this.barcode,
  });

  final String iconId;
  final String barcode;

  @override
  List<Object?> get props => [iconId, barcode];
}
