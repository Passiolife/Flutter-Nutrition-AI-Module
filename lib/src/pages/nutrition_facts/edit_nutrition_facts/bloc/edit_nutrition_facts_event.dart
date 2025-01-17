part of 'edit_nutrition_facts_bloc.dart';

sealed class EditNutritionFactsEvent extends Equatable {
  const EditNutritionFactsEvent();
}

final class ProcessEvent extends EditNutritionFactsEvent {
  const ProcessEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}
