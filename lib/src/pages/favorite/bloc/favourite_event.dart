part of 'favourite_bloc.dart';

abstract class FavoriteEvent {}

// Event will fetch all the record from favorite table in the DB.
class GetAllFavoritesEvent extends FavoriteEvent {}

// Event will update the record from favorite table in the DB.
class DoFavoriteUpdateEvent extends FavoriteEvent {
  final FoodRecord? data;

  DoFavoriteUpdateEvent({required this.data});
}

// Event will delete the record from favorite table in the DB.
class DoFavoriteDeleteEvent extends FavoriteEvent {
  FoodRecord? data;

  DoFavoriteDeleteEvent({required this.data});
}

// Event will add the data into log.
class DoLogEvent extends FavoriteEvent {
  final FoodRecord? data;
  final int index;

  DoLogEvent({required this.index, required this.data});
}
