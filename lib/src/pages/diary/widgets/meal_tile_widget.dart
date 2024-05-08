import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/custom_expansion_tile_widget.dart';
import '../../../common/widgets/passio_image_widget.dart';
import 'interfaces.dart';

typedef OnTapEdit = Function();
typedef OnTapDelete = Function();

// Define the InheritedWidget
class MealTileInherited extends InheritedWidget {
  final DayLog? dayLog;
  final DiaryListener? listener;

  const MealTileInherited({
    this.dayLog,
    this.listener,
    required super.child,
    super.key,
  });

  static MealTileInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MealTileInherited>();
  }

  @override
  bool updateShouldNotify(MealTileInherited oldWidget) {
    return dayLog != oldWidget.dayLog && listener != oldWidget.listener;
  }
}

class MealTileWidget extends StatefulWidget {
  const MealTileWidget({
    this.dayLog,
    this.listener,
    super.key,
  });

  final DayLog? dayLog;
  final DiaryListener? listener;

  @override
  State<MealTileWidget> createState() => _MealTileWidgetState();
}

class _MealTileWidgetState extends State<MealTileWidget> {
  List<({String mealTime, List<FoodRecord> foodRecords})> _mealTimes(
          BuildContext context) =>
      [
        (
          mealTime: context.localization?.breakfast ?? '',
          foodRecords: widget.dayLog?.breakfastRecords ?? []
        ),
        (
          mealTime: context.localization?.lunch ?? '',
          foodRecords: widget.dayLog?.lunchRecords ?? []
        ),
        (
          mealTime: context.localization?.dinner ?? '',
          foodRecords: widget.dayLog?.dinnerRecords ?? []
        ),
        (
          mealTime: context.localization?.snack ?? '',
          foodRecords: widget.dayLog?.snackRecords ?? []
        ),
      ];

  final controller = ScrollController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Get the full content height.
      /*final contentSize = controller.position.viewportDimension +
          controller.position.maxScrollExtent;
// Index to scroll to.
      final index = 3;
// Estimate the target scroll position.
      final target = contentSize * index / 4;
// Scroll to that position.
      controller.position.animateTo(
        target,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );*/

      /*Scrollable.ensureVisible(
        GlobalObjectKey('${context.localization?.snack}').currentContext!,
        duration: const Duration(seconds: 1), // duration for scrolling time
        curve: Curves.linear,
      );*/
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MealTileInherited(
      dayLog: widget.dayLog,
      listener: widget.listener,
      child: SlidableAutoCloseBehavior(
        child: ListView.separated(
          controller: controller,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: _mealTimes(context).length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final data = _mealTimes(context).elementAt(index);
            return _ExpansionTile(
              // key: GlobalObjectKey(data.mealTime),
              data: data.mealTime,
              foodRecords: data.foodRecords,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: AppDimens.h12);
          },
        ),
      ),
    );
  }
}

class _ExpansionTile extends StatelessWidget {
  final String data;
  final List<FoodRecord> foodRecords;

  const _ExpansionTile({
    required this.data,
    required this.foodRecords,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTileWidget(
      title: data,
      initiallyExpanded: true,
      children: foodRecords
          .map(
            (e) => _ExpansionTileChildWidget(
              iconId: e.iconId,
              foodName: e.name.toUpperCaseWord,
              foodSize:
                  '${e.getSelectedQuantity().format(places: 1)} ${e.getSelectedUnit().toUpperCaseWord} (${e.computedWeight.value.format(places: 0)} ${e.computedWeight.symbol})',
              foodCalories:
                  '${e.nutrientsSelectedSize().calories?.value.round() ?? 0} ${context.localization?.cal}',
              onEdit: () =>
                  MealTileInherited.of(context)?.listener?.onEditRecord(e),
              onDelete: () =>
                  MealTileInherited.of(context)?.listener?.onDeleteRecord(e),
            ),
          )
          .toList(),
    );
  }
}

class _ExpansionTileChildWidget extends StatelessWidget {
  const _ExpansionTileChildWidget({
    this.iconId,
    this.foodName,
    this.foodSize,
    this.foodCalories,
    this.onEdit,
    this.onDelete,
  });

  final String? iconId;
  final String? foodName;
  final String? foodSize;
  final String? foodCalories;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => onDelete?.call(),
        ),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit?.call(),
            backgroundColor: AppColors.indigo600Main,
            foregroundColor: Colors.white,
            label: context.localization?.edit ?? '',
          ),
          SlidableAction(
            onPressed: (context) => onDelete?.call(),
            backgroundColor: AppColors.red500,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: ListTile(
        onTap: () => onEdit?.call(),
        dense: true,
        visualDensity: VisualDensity.compact,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.only(
          left: AppDimens.w8,
          right: AppDimens.w16,
        ),
        leading: PassioImageWidget(
          iconId: iconId ?? '',
          radius: AppDimens.r20,
        ),
        title: Text(
          foodName ?? '',
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          foodSize ?? '',
          style: AppTextStyle.textSm,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          foodCalories ?? '',
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
        ),
      ),
    );
  }
}
