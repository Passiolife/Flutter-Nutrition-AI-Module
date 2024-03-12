import '../models/food_record/food_record_v3.dart';
import '../models/user_profile/user_profile_model.dart';

abstract interface class PassioConnector {
  // UserProfile
  Future<void> updateUserProfile(
      {required UserProfileModel userProfile, required bool isNew});

  Future<UserProfileModel?> fetchUserProfile();

  // Records
  Future<void> updateRecord(
      {required FoodRecord foodRecord, required bool isNew});

  Future<void> deleteRecord({required FoodRecord foodRecord});

  Future<List<FoodRecord>> fetchDayRecords({required DateTime dateTime});

  Future<List<FoodRecord>> fetchRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  /// Favorites

  /// Updates or adds a favorite food record based on [foodRecord].
  /// If [isNew] is true, it indicates that it's a new favorite.
  Future<void> updateFavorite(
      {required FoodRecord foodRecord, required bool isNew});

  Future<void> deleteFavorite({required FoodRecord foodRecord});

  Future<List<FoodRecord>?> fetchFavorites();
}
