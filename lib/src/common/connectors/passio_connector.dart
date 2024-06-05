import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';
import '../models/water_record/water_record.dart';
import '../models/weight_record/weight_record.dart';

abstract interface class PassioConnector {
  // User Profile Methods

  /// Updates the user profile with the provided [userProfile].
  /// If [isNew] is true, it indicates that it's a new profile.
  Future<void> updateUserProfile({
    required UserProfileModel userProfile,
    required bool isNew,
  });

  /// Fetches the user profile.
  ///
  /// Returns:
  ///   A [Future] that completes with the [UserProfileModel] if it exists, otherwise null.
  Future<UserProfileModel?> fetchUserProfile();

  // Record Methods

  /// Updates or adds a [foodRecord].
  /// If [isNew] is true, it indicates that it's a new record.
  Future<void> updateRecord({
    required FoodRecord foodRecord,
    required bool isNew,
  });

  /// Deletes the specified [foodRecord].
  Future<void> deleteRecord({required FoodRecord foodRecord});

  /// Fetches food records for a specific day [dateTime].
  ///
  /// Returns:
  ///   A [Future] that completes with a [List] of [FoodRecord] objects for the specified date.
  Future<List<FoodRecord>> fetchDayRecords({required DateTime dateTime});

  /// Fetches food records within a specified date range.
  ///
  /// Parameters:
  ///   - fromDate: The starting date of the range.
  ///   - endDate: The ending date of the range.
  ///
  /// Returns:
  ///   A [Future] that completes with a [List] of [FoodRecord] objects within the specified range.
  Future<List<FoodRecord>> fetchRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  // Favorite Methods

  /// Updates or adds a favorite food record based on [foodRecord].
  /// If [isNew] is true, it indicates that it's a new favorite.
  Future<void> updateFavorite({
    required FoodRecord foodRecord,
    required bool isNew,
  });

  /// Deletes the specified favorite [foodRecord].
  Future<void> deleteFavorite({required FoodRecord foodRecord});

  /// Fetches all favorite food records.
  ///
  /// Returns:
  ///   A [Future] that completes with a [List] of [FoodRecord] objects representing the favorites, or null if none exist.
  Future<List<FoodRecord>?> fetchFavorites();

  /// Checks if a favorite food record exists.
  ///
  /// Parameters:
  ///   - foodRecord: The [FoodRecord] to check for existence.
  ///
  /// Returns:
  ///   A [Future] that completes with a [bool] indicating if the favorite exists.
  Future<bool> favoriteExists({required FoodRecord foodRecord});

  // Water Methods

  /// Retrieves the amount of consumed water recorded for a specific date and time [dateTime].
  ///
  /// Returns:
  ///   A [Future] that completes with a [double] representing the consumed water amount.
  Future<double> fetchConsumedWater({required DateTime dateTime});

  /// Updates or adds a [waterRecord].
  /// If [isNew] is true, it indicates that it's a new record.
  Future<void> updateWater({
    required WaterRecord waterRecord,
    required bool isNew,
  });

  /// Retrieves a list of water consumption records within a specified date range.
  ///
  /// Parameters:
  ///   - fromDate: The starting date of the range.
  ///   - endDate: The ending date of the range.
  ///
  /// Returns:
  ///   A [Future] that completes with a [List] of [WaterRecord] objects within the specified range.
  Future<List<WaterRecord>> fetchWaterRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  /// Deletes a specific water consumption record [record].
  Future<void> deleteWaterRecord({required WaterRecord record});

  // Weight Methods

  /// Retrieves the measured weight recorded for a specific date and time [dateTime].
  ///
  /// Returns:
  ///   A [Future] that completes with a [double] representing the measured weight.
  Future<double> fetchMeasuredWeight({required DateTime dateTime});

  /// Updates or adds a weight record based on [record].
  /// If [isNew] is true, it indicates that it's a new record.
  Future<void> updateWeight({
    required WeightRecord record,
    required bool isNew,
  });

  /// Retrieves a list of weight records within a specified date range.
  ///
  /// Parameters:
  ///   - fromDate: The starting date of the range.
  ///   - endDate: The ending date of the range.
  ///
  /// Returns:
  ///   A [Future] that completes with a [List] of [WeightRecord] objects within the specified range.
  Future<List<WeightRecord>> fetchWeightRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  /// Deletes a specific weight record [record].
  Future<void> deleteWeightRecord({required WeightRecord record});
}
