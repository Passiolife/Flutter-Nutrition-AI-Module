import '../../../common/models/food_record/food_record.dart';

abstract interface class DiaryListener {
  void onEditRecord(FoodRecord record);
  void onDeleteRecord(FoodRecord record);
}