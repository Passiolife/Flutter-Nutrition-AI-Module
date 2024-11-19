import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import 'switch_row_widget.dart';

class TokenTrackingWidget extends StatelessWidget {
  const TokenTrackingWidget({
    this.tokenTrackingEnabled = false,
    this.onChangedTokenTracking,
    super.key,
  });

  // Breakfast
  final bool tokenTrackingEnabled;
  final ValueChanged<bool>? onChangedTokenTracking;

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
            context.localization?.tokenTracking ?? '',
            style: AppTextStyle.textBase.addAll(
                [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
          ),
          16.verticalSpace,
          SwitchRowWidget(
            title: context.localization?.enableTokenTracking ?? '',
            value: tokenTrackingEnabled,
            onChanged: onChangedTokenTracking,
          ),
        ],
      ),
    );
  }
}
