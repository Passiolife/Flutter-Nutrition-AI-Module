
import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';

abstract interface class PassioConnector {
  // UserProfile
  Future<void> updateUserProfile({required UserProfileModel userProfile, required bool isNew});
  Future<UserProfileModel?> fetchUserProfile();
  // Records
  Future<void> updateRecord({required FoodRecord foodRecord, required bool isNew});
  Future<void> deleteRecord({required FoodRecord foodRecord});
  Future<List<FoodRecord>?> fetchDayRecords({required DateTime dateTime});
  // Favorites
  Future<void> updateFavorite({required FoodRecord foodRecord, required bool isNew});
  Future<void> deleteFavorite({required FoodRecord foodRecord});
  Future<List<FoodRecord>?> fetchFavorites();
}