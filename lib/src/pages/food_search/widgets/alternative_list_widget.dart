import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_padding.dart';
import '../../../common/extension/string_extensions.dart';
import '../../../common/widgets/shimmer_widget.dart';

typedef OnSelectAlternative = Function(String alternative);

class AlternativeListWidget extends StatelessWidget {
  const AlternativeListWidget({
    required this.alternatives,
    this.onSelectAlternative,
    super.key,
  });

  final List<String> alternatives;

  final OnSelectAlternative? onSelectAlternative;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.h56 + AppDimens.h8,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: alternatives.length,
        scrollDirection: Axis.horizontal,
        padding: AppPadding.ph16 + AppPadding.pv4,
        itemBuilder: (BuildContext context, int index) {
          final data = alternatives.elementAt(index);
          if (data != '-1') {
            return _AlternativeRowWidget(
              data: data,
              onSelectAlternative: onSelectAlternative,
            );
          } else {
            return const _AlternativeRowSkeletonWidget();
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: AppDimens.w8);
        },
      ),
    );
  }
}


class _AlternativeRowWidget extends StatelessWidget {
  const _AlternativeRowWidget({required this.data, this.onSelectAlternative});
  final String? data;

  final OnSelectAlternative? onSelectAlternative;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      height: AppDimens.h76,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.blue50,
          highlightColor: AppColors.blue50,
          onTap: () => onSelectAlternative?.call(data.toUpperCaseWord),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.r16),
            child: Center(
              child: Text(
                data.toUpperCaseWord,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.semiBold
                ]).copyWith(color: AppColors.gray900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlternativeRowSkeletonWidget extends StatelessWidget {
  const _AlternativeRowSkeletonWidget();

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget.rectangular(
      height: AppDimens.h52,
      width: AppDimens.w120,
      baseColor: AppColors.gray300,
      highlightColor: AppColors.gray200,
    );
  }
}
