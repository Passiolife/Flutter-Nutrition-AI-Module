import 'package:flutter/material.dart';

import '../../../common/models/food_record/food_record.dart';
import 'food_record_list_row.dart';
import 'no_data_widget.dart';

class TabSnackWidget extends StatefulWidget {
  final List<FoodRecord?> data;
  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  const TabSnackWidget(
      {required this.data, this.onDeleteItem, this.onEditItem, super.key});

  @override
  State<TabSnackWidget> createState() => _TabSnackWidgetState();
}

class _TabSnackWidgetState extends State<TabSnackWidget> {
  final List<FoodRecord?> _foodRecordsList = [];

  @override
  void initState() {
    _foodRecordsList
      ..addAll(widget.data)
      ..removeWhere(
          (element) => element?.mealLabel?.value != MealLabel.snack.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _foodRecordsList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _foodRecordsList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = _foodRecordsList.elementAt(index);
              return FoodRecordListRow(
                key: ObjectKey(data?.passioID),
                data: data,
                onDeleteItem: widget.onDeleteItem,
                onEditItem: widget.onEditItem,
                index: index,
              );
            },
          )
        : const NoFoodRecordsWidget();
  }
}
