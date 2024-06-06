import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/widgets/custom_expansion_tile_widget.dart';
import '../../../common/widgets/typedefs.dart';

class EntryTileChildData {
  final int id;
  final String value;
  final String unit;
  final DateTime dateTime;

  EntryTileChildData({
    required this.id,
    required this.value,
    required this.unit,
    required this.dateTime,
  });
}

abstract interface class EntryTileListener {
  void onEditLog(int id);

  void onDeleteLog(int id);
}

class EntryTileWidget extends StatelessWidget {
  const EntryTileWidget({
    this.rangeDates,
    this.data,
    this.isMonthRange = false,
    this.listener,
    super.key,
  });

  final RangeDates? rangeDates;
  final List<EntryTileChildData>? data;
  final EntryTileListener? listener;
  final bool isMonthRange;

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: CustomExpansionTileWidget(
        title: rangeDates?.startDate.rangeString(
            isMonthRange: isMonthRange,
            endDateTime: rangeDates?.endDate ?? DateTime.now()),
        children: data
                ?.map(
                  (e) => EntryTileChildWidget(
                    data: e,
                    onEdit: () => listener?.onEditLog.call(e.id),
                    onDelete: () => listener?.onDeleteLog.call(e.id),
                  ),
                )
                .toList() ??
            [],
      ),
    );
  }
}

class EntryTileChildWidget extends StatelessWidget {
  const EntryTileChildWidget({
    required this.data,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final EntryTileChildData data;

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
            onPressed: (_) => onEdit?.call(),
            backgroundColor: AppColors.indigo600Main,
            foregroundColor: Colors.white,
            label: context.localization?.edit ?? '',
          ),
          SlidableAction(
            autoClose: false,
            onPressed: (_) => onDelete?.call(),
            backgroundColor: AppColors.red500,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w8,
          vertical: AppDimens.h8,
        ),
        child: ListTile(
          onTap: onEdit,
          dense: true,
          visualDensity: VisualDensity.compact,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.only(
            left: AppDimens.w8,
            right: AppDimens.w16,
          ),
          title: RichText(
            text: TextSpan(
              text: data.value,
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.semiBold
              ]).copyWith(
                color: AppColors.gray900,
              ),
              children: [
                TextSpan(
                  text: ' ${data.unit}',
                  style: AppTextStyle.textSm
                      .addAll([AppTextStyle.textSm.leading5]).copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.dateTime.formatToString(format15),
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
              ),
              Text(
                data.dateTime.formatToString(format3),
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
