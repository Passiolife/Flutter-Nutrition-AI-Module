import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({required this.searchQuery, super.key});
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.customShadow,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimens.w16,
        vertical: AppDimens.h8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.r8,
        vertical: AppDimens.h16,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppImages.icCloseSolid,
            width: AppDimens.r30,
            height: AppDimens.r30,
            colorFilter:
                const ColorFilter.mode(AppColors.red600Error, BlendMode.srcIn),
          ),
          SizedBox(width: AppDimens.w8),
          Expanded(
            child: Text(
              '$searchQuery ${context.localization?.noFoodSearchResultMessage}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray900),
            ),
          ),
        ],
      ),
    );
  }
}
