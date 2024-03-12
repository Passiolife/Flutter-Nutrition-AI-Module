import '../../../common/models/food_record/food_record_v3.dart';

abstract interface class DiaryListener {
  void onEditRecord(FoodRecord record);
  void onDeleteRecord(FoodRecord record);
}