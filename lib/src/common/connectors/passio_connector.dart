import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';
import '../models/water_record/water_record.dart';
import '../models/weight_record/weight_record.dart';

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

  Future<bool> favoriteExists({required FoodRecord foodRecord});

  // Water

  /// Retrieves the amount of consumed water recorded for a specific date and time.
  ///
  /// This method is used within the dashboard to fetch the consumed water quantity
  /// for the given [dateTime].
  ///
  /// Parameters:
  ///   - dateTime: The date and time for which the consumed water quantity is to be fetched.
  ///
  /// Returns:
  ///   A [Future] that completes with an [int] representing the consumed water amount.
  Future<double> fetchConsumedWater({required DateTime dateTime});

  Future<int> updateWater(
      {required WaterRecord waterRecord, required bool isNew});

  /// Retrieves a list of water consumption records within a specified date range.
  ///
  /// This method is used to fetch water consumption records from the [fromDate] to the [endDate],
  /// inclusive, within the specified range.
  ///
  /// Parameters:
  ///   - fromDate: The starting date of the date range from which water consumption records are to be fetched.
  ///   - endDate: The ending date of the date range from which water consumption records are to be fetched.
  ///
  /// Returns:
  ///   A [Future] that completes with a [List] of [WaterRecord] objects representing
  ///   the water consumption records within the specified date range.
  Future<List<WaterRecord>> fetchWaterRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  /// Deletes a specific water consumption record.
  ///
  /// This method is used to delete the provided [record] of water consumption.
  ///
  /// Parameters:
  ///   - record: The [WaterRecord] object representing the water consumption record to be deleted.
  ///
  /// Returns:
  ///   A [Future] that completes once the deletion of the specified [record] is successful,
  ///   without returning any value.
  Future<void> deleteWaterRecord({required WaterRecord record});


  // Weight

  Future<double> fetchMeasuredWeight({required DateTime dateTime});

  Future<int> updateWeight(
      {required WeightRecord weightRecord, required bool isNew});

  Future<List<WeightRecord>> fetchWeightRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  Future<void> deleteWeightRecord({required WeightRecord record});

}
