part of 'edit_food_bloc.dart';

abstract class EditFoodState extends Equatable {
  const EditFoodState();
}

class EditFoodInitial extends EditFoodState {
  const EditFoodInitial();

  @override
  List<Object> get props => [];
}

class ConversionLoadingState extends EditFoodState {
  const ConversionLoadingState();

  @override
  List<Object?> get props => [];
}

class ConversionSuccessState extends EditFoodState {
  const ConversionSuccessState({
    required this.foodRecord,
    required this.sliderData,
  });

  final FoodRecord? foodRecord;
  final SliderData sliderData;

  @override
  List<Object?> get props => [foodRecord, sliderData];
}

class ConversionFailureState extends EditFoodState {
  const ConversionFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class UpdateServingQuantitySuccessState extends EditFoodState {
  const UpdateServingQuantitySuccessState({
    required this.quantity,
    required this.foodRecord,
    required this.sliderData,
    required this.unit,
  });

  final FoodRecord? foodRecord;
  final SliderData sliderData;
  final double quantity;
  final String unit;

  @override
  List<Object?> get props => [foodRecord, sliderData, quantity, unit];
}

class UpdateServingUnitSuccessState extends EditFoodState {
  const UpdateServingUnitSuccessState({required this.foodRecord});

  final FoodRecord? foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

class UpdateDateSuccessState extends EditFoodState {
  const UpdateDateSuccessState({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

class AddIngredientSuccessState extends EditFoodState {
  const AddIngredientSuccessState({required this.ingredientsCount});

  final int ingredientsCount;

  @override
  List<Object?> get props => [ingredientsCount];
}

class RemoveIngredientSuccessState extends EditFoodState {
  const RemoveIngredientSuccessState({required this.ingredientsCount});

  final int ingredientsCount;

  @override
  List<Object?> get props => [ingredientsCount];
}

class ReplaceIngredientSuccessState extends EditFoodState {
  const ReplaceIngredientSuccessState({required this.ingredient});

  final FoodRecordIngredient ingredient;

  @override
  List<Object?> get props => [ingredient];
}

class LogSuccessState extends EditFoodState {
  const LogSuccessState();

  @override
  List<Object?> get props => [];
}

class FavoriteChangeSuccessState extends EditFoodState {
  final bool isFavorite;

  const FavoriteChangeSuccessState({required this.isFavorite});

  @override
  List<Object?> get props => [isFavorite];
}

class LogDeleteSuccessState extends EditFoodState {
  const LogDeleteSuccessState({required this.milliseconds});

  final int milliseconds;

  @override
  List<Object?> get props => [milliseconds];
}

class UserFoodFlowState extends EditFoodState {
  const UserFoodFlowState({required this.timeStamp});
  final int timeStamp;

  @override
  List<Object?> get props => [timeStamp];
}

class UserFoodFetchSuccessState extends EditFoodState {
  const UserFoodFetchSuccessState({
    required this.logUpdateOnCreate,
    this.userFoodRecord,
  });

  final FoodRecord? userFoodRecord;
  final bool logUpdateOnCreate;

  @override
  List<Object?> get props => [logUpdateOnCreate, userFoodRecord];
}

class UserFoodFetchFailureState extends EditFoodState {
  const UserFoodFetchFailureState({required this.logUpdateOnCreate});

  final bool logUpdateOnCreate;

  @override
  List<Object?> get props => [logUpdateOnCreate];
}
