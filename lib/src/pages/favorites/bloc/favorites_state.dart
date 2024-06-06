part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();

  @override
  List<Object> get props => [];
}

// States for [GetAllFavoritesEvent]
class GetAllFavouritesSuccessState extends FavoritesState {
  final List<FoodRecord?>? data;

  const GetAllFavouritesSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetAllFavouritesFailureState extends FavoritesState {
  final String message;

  const GetAllFavouritesFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

// States for [DoFavoriteDeleteEvent]
class FavoriteDeleteSuccessState extends FavoritesState {
  const FavoriteDeleteSuccessState({required this.milliseconds});

  final int milliseconds;

  @override
  List<Object?> get props => [milliseconds];
}

class FavoriteDeleteFailureState extends FavoritesState {
  final String message;

  const FavoriteDeleteFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

// States for [DoLogEvent]
class FoodRecordLogSuccessState extends FavoritesState {
  const FoodRecordLogSuccessState({required this.createdAt});

  final DateTime? createdAt;

  @override
  List<Object?> get props => [createdAt];
}

class FoodRecordLogFailureState extends FavoritesState {
  final String message;

  const FoodRecordLogFailureState({required this.message});

  @override
  List<Object?> get props => [];
}
