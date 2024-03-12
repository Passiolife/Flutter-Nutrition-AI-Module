import '../../../common/models/food_record/food_record_v3.dart';

abstract interface class FoodScanListener {
  void onDragResult(bool isCollapsed);
  void onLog();
  void onEdit();

}