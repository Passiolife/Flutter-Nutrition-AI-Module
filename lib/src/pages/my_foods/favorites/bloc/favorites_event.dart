part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

// Event will fetch all the record from favorite table in the DB.
class GetAllFavoritesEvent extends FavoritesEvent {
  const GetAllFavoritesEvent();

  @override
  List<Object?> get props => [];
}

// Event will delete the record from favorite table in the DB.
class DoFavoriteDeleteEvent extends FavoritesEvent {
  final FoodRecord? data;

  const DoFavoriteDeleteEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

// Event will add the data into log.
class DoLogEvent extends FavoritesEvent {
  final FoodRecord? data;

  const DoLogEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
