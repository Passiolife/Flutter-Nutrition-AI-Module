import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_drop_down_menu.dart';

class UnitsForProfileWidget extends StatelessWidget {
  const UnitsForProfileWidget({
    this.initialHeightMeasurement,
    this.onHeightMeasurementChanged,
    this.initialWeightMeasurement,
    this.onWeightMeasurementChanged,
    super.key,
  });

  // Height Related
  final MeasurementSystem? initialHeightMeasurement;
  final ValueChanged<MeasurementSystem?>? onHeightMeasurementChanged;

  // Weight Related
  final MeasurementSystem? initialWeightMeasurement;
  final ValueChanged<MeasurementSystem?>? onWeightMeasurementChanged;

  List<DropdownMenuEntry<MeasurementSystem>> _getHeightUnits(BuildContext context) => [
        DropdownMenuEntry(
            value: MeasurementSystem.imperial,
            label:
                '${context.localization?.feet ?? ''}, ${context.localization?.inches ?? ''}'),
        DropdownMenuEntry(
            value: MeasurementSystem.metric,
            label:
                '${context.localization?.meter ?? ''}, ${context.localization?.centimeter ?? ''}'),
      ];

  List<DropdownMenuEntry<MeasurementSystem>> _getWeightUnits(BuildContext context) => [
        DropdownMenuEntry(
            value: MeasurementSystem.imperial,
            label: context.localization?.lbs?.toUpperCaseWord ?? ''),
        DropdownMenuEntry(
            value: MeasurementSystem.metric,
            label: context.localization?.kg?.toUpperCaseWord ?? ''),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.unitsForMyProfile ?? '',
            style: AppTextStyle.textBase.addAll(
                [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
          ),
          16.verticalSpace,
          _RowWidget(
            title: context.localization?.length ?? '',
            dropdownMenuEntries: _getHeightUnits(context),
            initialSelection: initialHeightMeasurement,
            onSelected: onHeightMeasurementChanged,
          ),
          16.verticalSpace,
          _RowWidget(
            title: context.localization?.weight ?? '',
            dropdownMenuEntries: _getWeightUnits(context),
            initialSelection: initialWeightMeasurement,
            onSelected: onWeightMeasurementChanged,
          ),
        ],
      ),
    );
  }
}

class _RowWidget<T> extends StatelessWidget {
  final String? title;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;

  const _RowWidget({
    this.title,
    this.dropdownMenuEntries = const [],
    this.initialSelection,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: AppTextStyle.textSm
                .addAll([AppTextStyle.textSm.leading5, AppTextStyle.medium]).copyWith(color: AppColors.gray500),
          ),
        ),
        Expanded(
          child: AppDropDownMenu(
            dropdownMenuEntries: dropdownMenuEntries,
            initialSelection: initialSelection,
            onSelected: onSelected,
          ),
        ),
      ],
    );
  }
}
