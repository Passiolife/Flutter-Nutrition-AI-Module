part of 'favourite_bloc.dart';

abstract class FavoriteState {}

class FavouriteInitial extends FavoriteState {}

// States for [GetAllFavoritesEvent]
class GetAllFavouritesSuccessState extends FavoriteState {
  final List<FoodRecord?>? data;

  GetAllFavouritesSuccessState({required this.data});
}

class GetAllFavouritesFailureState extends FavoriteState {
  final String message;

  GetAllFavouritesFailureState({required this.message});
}

// States for [DoFavoriteUpdateEvent]
class FavoriteUpdateSuccessState extends FavoriteState {}

class FavoriteUpdateFailureState extends FavoriteState {
  final String message;

  FavoriteUpdateFailureState({required this.message});
}

// States for [DoFavoriteDeleteEvent]
class FavoriteDeleteSuccessState extends FavoriteState {}

class FavoriteDeleteFailureState extends FavoriteState {
  final String message;

  FavoriteDeleteFailureState({required this.message});
}

// States for [DoLogEvent]
class FoodRecordLogLoadingState extends FavoriteState {
  final int index;
  FoodRecordLogLoadingState({required this.index});
}

class FoodRecordLogSuccessState extends FavoriteState {}

class FoodRecordLogFailureState extends FavoriteState {
  final String message;

  FoodRecordLogFailureState({required this.message});
}
