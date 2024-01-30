import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';

/// Abstract interface for Passio connector, defining methods for user profile, records, and favorites.
abstract interface class PassioConnector {
  /// UserProfile

  /// Updates the user profile with the provided [userProfile].
  /// If [isNew] is true, it indicates that it's a new user profile.
  Future<void> updateUserProfile(
      {required UserProfileModel userProfile, required bool isNew});

  /// Fetches the user profile.
  Future<UserProfileModel?> fetchUserProfile();

  /// Records

  /// Updates or adds a food record based on [foodRecord].
  /// If [isNew] is true, it indicates that it's a new food record.
  Future<void> updateRecord(
      {required FoodRecord foodRecord, required bool isNew});

  /// Deletes the provided [foodRecord].
  Future<void> deleteRecord({required FoodRecord foodRecord});

  /// Fetches a list of food records for the specified [dateTime].
  Future<List<FoodRecord>?> fetchDayRecords({required DateTime dateTime});

  /// Favorites

  /// Updates or adds a favorite food record based on [foodRecord].
  /// If [isNew] is true, it indicates that it's a new favorite.
  Future<void> updateFavorite(
      {required FoodRecord foodRecord, required bool isNew});

  /// Deletes the provided [foodRecord] from favorites.
  Future<void> deleteFavorite({required FoodRecord foodRecord});

  /// Fetches a list of favorite food records.
  Future<List<FoodRecord>?> fetchFavorites();
}
