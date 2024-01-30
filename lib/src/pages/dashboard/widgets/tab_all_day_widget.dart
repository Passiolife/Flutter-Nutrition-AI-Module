import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../common/constant/dimens.dart';
import '../../../common/models/food_record/food_record.dart';
import 'food_record_list_row.dart';
import 'no_data_widget.dart';

class TabAllDayWidget extends StatefulWidget {
  final List<FoodRecord?> data;
  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  const TabAllDayWidget({required this.data, this.onDeleteItem, this.onEditItem, super.key});

  @override
  State<TabAllDayWidget> createState() => _TabAllDayWidgetState();
}

class _TabAllDayWidgetState extends State<TabAllDayWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? SlidableAutoCloseBehavior(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              padding: EdgeInsets.only(bottom: Dimens.h100, top: Dimens.h8),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = widget.data.elementAt(index);
                return FoodRecordListRow(
                  key: ObjectKey(data?.passioID),
                  data: data,
                  onDeleteItem: widget.onDeleteItem,
                  onEditItem: widget.onEditItem,
                  index: index,
                );
              },
            ),
          )
        : const NoFoodRecordsWidget();
  }
}
