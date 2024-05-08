abstract interface class FoodScanListener {
  void onDragResult(bool isCollapsed);

  void onLog();

  void onEdit(int? index);

  void onTapSearch();
}
